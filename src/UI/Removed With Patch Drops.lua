-- App locals
local appName, app = ...;
local tinsert, ipairs = tinsert, ipairs;
local GetRelativeValue = app.GetRelativeValue;

-- Temp Functions
-- TODO: Move this to a module.
local function BuildSourceTextForChat(group, l)
	if group.parent then
		if l < 1 then
			return BuildSourceTextForChat(group.parent, l + 1);
		else
			return BuildSourceTextForChat(group.parent, l + 1) .. " > " .. (group.text or "*");
		end
		return group.text or "*";
	end
	return "ATT";
end

-- Local functions
local ExcludeRecipes, ExcludeRemovedMaps, ExcludeRemovedRares;
local AllowedHeaders = {
	[app.HeaderConstants.RARES] = true,
	[app.HeaderConstants.ZONE_DROPS] = true,
};
local function ExpandGroupsRecursively(group, expanded, manual)
	if group.g and (not group.itemID or manual) then
		group.expanded = expanded;
		for i, subgroup in ipairs(group.g) do
			ExpandGroupsRecursively(subgroup, expanded, manual);
		end
	end
end
local function ReapplyExpand(g, g2)
	for j,p in ipairs(g2) do
		local found = false;
		local key = p.key;
		local id = p[key];
		for i,o in ipairs(g) do
			if o[key] == id then
				found = true;
				if o.expanded then
					if not p.expanded then
						p.expanded = true;
						if o.g and p.g then ReapplyExpand(o.g, p.g); end
					end
				end
				break;
			end
		end
	end
end
local function Export(g, strings)
	if g then
		for i,o in ipairs(g) do
			if o.itemID then
				tinsert(strings, o.itemID .. "\\t" .. (o.name or RETRIEVING_DATA) .. "\\t" .. (o.spellID or 0) .. "\\t" .. BuildSourceTextForChat(o, 0));
			end
			Export(o.g, strings);
		end
	end
end

-- Implementation
app:GetWindow("RWPD", {
	parent = UIParent,
	Silent = true,
	OnInit = function(self, handlers)
		SLASH_ATTRWPDROPS1 = "/attrwpdrops";
		SlashCmdList["ATTRWPDROPS"] = function()
			self:Toggle();
		end
	end,
	OnLoad = function(self, settings)
		ExcludeRecipes = settings.ExcludeRecipes;
		ExcludeRemovedMaps = settings.ExcludeRemovedMaps;
		ExcludeRemovedRares = settings.ExcludeRemovedRares;
		if ExcludeRecipes == nil then ExcludeRecipes = true; end
		if ExcludeRemovedMaps == nil then ExcludeRemovedMaps = true; end
		if ExcludeRemovedRares == nil then ExcludeRemovedRares = true; end
	end,
	OnSave = function(self, settings)
		settings.ExcludeRecipes = ExcludeRecipes;
		settings.ExcludeRemovedMaps = ExcludeRemovedMaps;
		settings.ExcludeRemovedRares = ExcludeRemovedRares;
	end,
	OnRebuild = function(self)
		if self.data then return true; end
		local options = {
			{	-- Exclude Recipes Button
				text = "Exclude Recipes",
				icon = "Interface/Icons/inv_scroll_05",
				description = "Press this button to toggle excluding Recipes.",
				visible = true,
				priority = 6,
				OnClick = function(row, button)
					ExcludeRecipes = not ExcludeRecipes;
					wipe(self.data.g);
					self:Rebuild();
					return true;
				end,
				OnUpdate = function(data)
					data.saved = ExcludeRecipes;
					return true;
				end,
			},
			{	-- Exclude Removed Maps Button
				text = "Exclude Removed Maps",
				icon = "Interface\\Icons\\Inv_misc_map02",
				description = "Press this button to toggle excluding Maps that get Removed in the future.",
				visible = true,
				priority = 6,
				OnClick = function(row, button)
					ExcludeRemovedMaps = not ExcludeRemovedMaps;
					wipe(self.data.g);
					self:Rebuild();
					return true;
				end,
				OnUpdate = function(data)
					data.saved = ExcludeRemovedMaps;
					return true;
				end,
			},
			{	-- Exclude Removed Rares Button
				text = "Exclude Removed Rares",
				icon = app.asset("Interface_Rare"),
				description = "Press this button to toggle excluding Rares that get Removed in the future.",
				visible = true,
				priority = 6,
				OnClick = function(row, button)
					ExcludeRemovedRares = not ExcludeRemovedRares;
					wipe(self.data.g);
					self:Rebuild();
					return true;
				end,
				OnUpdate = function(data)
					data.saved = ExcludeRemovedRares;
					return true;
				end,
			},
			{	-- Export Data Button
				text = "Export Data",
				icon = "Interface\\Icons\\Spell_Shadow_LifeDrain02",
				description = "Press this button to open an edit box containing the full content of the list.",
				visible = true,
				priority = 6,
				OnClick = function(row, button)
					local data, s, count = {}, "", 0;
					Export(self.data.g, data);
					for i,str in ipairs(data) do
						if count > 0 then
							s = s .. "\n";
						end
						s = s .. str;
						count = count + 1;
					end
					
					app:ShowPopupDialogWithMultiLineEditBox(s);
					return true;
				end,
				OnUpdate = app.ReturnTrue,
			},
		};
		
		local filteredData = app:BuildSearchFilteredResponse(app:GetDataCache().g, function(group)
			if group.rwp and group.itemID then
				local headerID = GetRelativeValue(group, "headerID");
				if headerID and AllowedHeaders[headerID] then
					return true;
				end
			end
		end);
		
		self.data = {
			text = "Removed With Patch Drops",
			icon = app.asset("WindowIcon_RWP"), 
			description = "This window shows you all of the things excluding recipes that get removed in a future patch from zone drop, rare, and world drop sources.",
			visible = true, 
			expanded = true,
			back = 1,
			indent = 0,
			g = { },
			OnUpdate = function(data)
				local g = data.g;
				if #g < 1 then
					for i,option in ipairs(options) do
						option.parent = data;
						tinsert(g, option);
					end
					local results = app:BuildSearchFilteredResponse(filteredData, function(group)
						if group.rwp and group.itemID and (not ExcludeRecipes or (not group.f or group.f ~= 200)) then
							local removed = not group.parent.awp and (group.parent.rwp or group.parent.u == 1);
							if group.parent.npcID then
								return not ExcludeRemovedRares or not removed;
							else
								return not ExcludeRemovedMaps or not removed;
							end
						end
					end);
					if #results > 0 then
						for i,result in ipairs(results) do
							tinsert(g, result);
						end
					end
					if self.oldG then ReapplyExpand(self.oldG, results); end
					self.oldG = results;
				end
			end,
		};
		return true;
	end,
});
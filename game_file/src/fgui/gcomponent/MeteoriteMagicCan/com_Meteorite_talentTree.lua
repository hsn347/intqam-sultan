local baseComponent = require("fgui.base.baseComponent")
local com_Meteorite_talentTree = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MeteoriteMagicCan/com_Meteorite_talentTree1", com_Meteorite_talentTree)
fgui.register_extension("ui://MeteoriteMagicCan/com_Meteorite_talentTree2", com_Meteorite_talentTree)
fgui.register_extension("ui://MeteoriteMagicCan/com_Meteorite_talentTree3", com_Meteorite_talentTree)
fgui.register_extension("ui://MeteoriteMagicCan/com_Meteorite_talentTree4", com_Meteorite_talentTree)
fgui.register_extension("ui://MeteoriteMagicCan/com_Meteorite_talentTree5", com_Meteorite_talentTree)
fgui.register_extension("ui://MeteoriteMagicCan/com_Meteorite_talentTree6", com_Meteorite_talentTree)
fgui.register_extension("ui://MeteoriteMagicCan/com_Meteorite_talentTree7", com_Meteorite_talentTree)
fgui.register_extension("ui://MeteoriteMagicCan/com_Meteorite_talentTree8", com_Meteorite_talentTree)
local meteorMagicCtrl = SoraDGetCtrl("meteorMagicCtrl")
local meteorMagicRead = include("meteorMagicRead")
function com_Meteorite_talentTree:onInit()
	self.isInited = true
end
function com_Meteorite_talentTree:onShow()
end
function com_Meteorite_talentTree:initData(config, curProjectID, curPanel)
	self.magicCfgs, _ENV, self.idGroups = config.idGroup, config.idGroup, config.idGroup
	for i, v in ipairs(self.idGroups) do
		local magicId = meteorMagicRead.getMagicId(v, 1)
		local magicCfg = meteorMagicRead.getMagicCfg(magicId)
		table.insert(self.magicCfgs, magicCfg)
	end
	self.curProjectID = curProjectID
	self.curPanel = curPanel
end
function com_Meteorite_talentTree:updateView()
	self.keyMap, meteorMagicCtrl, self.data = meteorMagicCtrl:getProjectData(self.curProjectID), meteorMagicCtrl:getProjectData(self.curProjectID), meteorMagicCtrl:getProjectData(self.curProjectID)
	for i, v in ipairs(self.idGroups) do
		self.keyMap[v] = i
		self.fields["talent" .. i]:setIDGruop(v, self.curProjectID)
		local lv = self.data.light[tostring(v)]
		local isActive = self.fields["talent" .. i]:setData(lv)
		if isActive then
			self.curPanel:scrollToCenter(self.fields["talent" .. i], true)
		end
		self:updateLines(i, lv)
	end
	self.isInited = false
end
function com_Meteorite_talentTree:updateLines(index, lv)
	lv = lv ~= nil and lv or 0
	local magicCfg = self.magicCfgs[index]
	local preMagicIds = 0 < #magicCfg.specifiedId and magicCfg.specifiedId or magicCfg.thereintoId
	self:updateLine(self.fields["line" .. index], 0 < lv)
	for i, v in ipairs(preMagicIds) do
		local idGroup = meteorMagicRead.getIdGroup(v)
		local preLv = self.data.light[tostring(idGroup)]
		local isLight = preLv ~= nil and 0 < preLv
		self:updateLine(self.fields["line" .. index .. "_" .. self.keyMap[idGroup]], 0 < lv and isLight)
	end
end
function com_Meteorite_talentTree:updateLine(line, isVisible)
	if line == nil then
		return
	end
	local line_light = fguiHelper.get_fields(line).bar
	local line_light2 = fguiHelper.get_fields(line).bar2
	if not line_light:isVisible() and isVisible and not self.isInited then
		line_light:setScaleY(0)
		line_light:setScaleX(1)
		line_light:runAction(ffa.scaleTo(0.5, 1, 1))
	end
	line_light:setVisible(isVisible)
end
function com_Meteorite_talentTree:getObjByIdGroup(idGroup)
	return self.fields["talent" .. self.keyMap[idGroup]]
end
function com_Meteorite_talentTree:showPreviews(idGroups)
	for i, v in ipairs(self.idGroups) do
		for i2, v2 in ipairs(idGroups) do
			if v == v2 then
				print("talent" .. i, v2)
				self.fields["talent" .. i]:showPreview()
				self:previewLine(i, true)
			end
		end
	end
end
function com_Meteorite_talentTree:hidePreview(idGroups)
	for i, v in ipairs(self.idGroups) do
		for i2, v2 in ipairs(idGroups) do
			if v == v2 then
				print("talent" .. i, v2)
				self.fields["talent" .. i]:hidePreview()
				self:previewLine(i, false)
			end
		end
	end
end
function com_Meteorite_talentTree:previewLine(index, isShow)
	local line = self.fields["line" .. index]
	if line ~= nil then
		local line_light2 = fguiHelper.get_fields(line).bar2
		line_light2:setVisible(isShow)
	end
	local magicCfg = self.magicCfgs[index]
	local preMagicIds = #magicCfg.specifiedId > 0 and magicCfg.specifiedId or magicCfg.thereintoId
	for i, v in ipairs(preMagicIds) do
		local idGroup = meteorMagicRead.getIdGroup(v)
		local line = self.fields["line" .. index .. "_" .. self.keyMap[idGroup]]
		if line ~= nil then
			local line_light2 = fguiHelper.get_fields(line).bar2
			line_light2:setVisible(isShow)
		end
	end
end
return com_Meteorite_talentTree

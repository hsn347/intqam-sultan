local roaringFlameWarRead = include("roaringFlameWarRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_campBuildTitle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlameWar/Com_campBuildTitle", Com_campBuildTitle)
function Com_campBuildTitle:onInit()
	self.isLaunched = false
	self.baseHeight = self:getHeight()
	self.fields.Panel_touch:addClickListener(handler(self, self.btnClickCallBack))
	local _fields = fguiHelper.get_fields(self.fields.Com_show)
	self.fields.List = _fields.List
	_fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	_fields.Text_noData:setString(i18n("flames_dunes_text240"))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
end
function Com_campBuildTitle:onShow()
end
function Com_campBuildTitle:onItemRenderer(index, obj)
	local objId = self.objIdList[index + 1]
	obj:initData(objId)
end
function Com_campBuildTitle:initData(subType, objIdList)
	self.subType = subType
	self.objIdList = objIdList
	local buildTypeIcon = roaringFlameWarRead.getBuildTypeIcon(subType)
	self.fields.Load_build:setURL(buildTypeIcon)
	local buildName = roaringFlameWarRead.getBuildName(subType)
	self.fields.Text_name:setString(buildName)
	local roaringFlameWarRead, levelMap = self.fields.Text_name.setString, self.fields.Text_name.setString
	for __, objId in ipairs(objIdList) do
		levelMap[objId] = roaringFlameWarRead.getBuildLevel(objId)
	end
	table.sort(objIdList, function(a, b)
		local a_level = levelMap[a]
		local b_level = levelMap[b]
		if a_level ~= b_level then
			return a_level > b_level
		end
		return b < a
	end)
	self.objIdList = objIdList
	self.fields.Text_count:setString(#self.objIdList)
	self.fields.Text_des:setVisible(false)
	roaringFlameWarRead = self.fields.Text_des.setVisible
	self.fields.Text_des.setVisible[gWorldTypeServerDef.subTypeRoaringFlameWarRuins] = true
	local roaringFlameWarRead, self.fields.Text_des.setVisible[gWorldTypeServerDef.subTypeRoaringFlameWarStation], config1 = gWorldTypeServerDef.subTypeRoaringFlameWarStation, true, self.fields.Text_des.setVisible
	gWorldTypeServerDef.subTypeRoaringFlameWarStation[gWorldTypeServerDef.subTypeRoaringFlameWarMine] = true
	gWorldTypeServerDef.subTypeRoaringFlameWarStation[gWorldTypeServerDef.subTypeRoaringFlameWarPhoenix] = true
	local gWorldTypeServerDef.subTypeRoaringFlameWarStation[gWorldTypeServerDef.subTypeRoaringFlameWarWoods], config2 = true, gWorldTypeServerDef.subTypeRoaringFlameWarStation
	if config1[subType] then
		self.fields.Text_des:setVisible(true)
		local maxScore = 0
		for __, objId in ipairs(objIdList) do
			local score = roaringFlameWarRead.getBuildCostPoint(objId)
			if maxScore < score then
				maxScore = score
			end
		end
		if 0 < maxScore then
			self.fields.Text_des:setVisible(true)
			roaringFlameWarRead = nil
			;(nil).num = maxScore
			self.fields.Text_des:setString(i18n("flames_dunes_text95", nil))
		end
	elseif config2[subType] then
		self.fields.Text_des:setVisible(true)
		local maxLv = 0
		for __, objId in ipairs(objIdList) do
			local level = roaringFlameWarRead.getBuildLevel(objId)
			if maxLv < level then
				maxLv = level
			end
		end
		if 0 < maxLv then
			self.fields.Text_des:setVisible(true)
			roaringFlameWarRead = i18n("flames_dunes_text95", nil)
			i18n("flames_dunes_text95", nil).num = maxLv
			self.fields.Text_des:setString(i18n("flames_dunes_text96", i18n("flames_dunes_text95", nil)))
		end
	end
	local _fields = fguiHelper.get_fields(self.fields.Com_show)
	local buildTypeDes = roaringFlameWarRead.getBuildTypeDes(subType)
	_fields.Text_des:setString(buildTypeDes)
	self:setState(self.isLaunched)
end
function Com_campBuildTitle:btnClickCallBack()
	SoraDPlaySound()
	self:setState(not self.isLaunched)
end
function Com_campBuildTitle:setState(state)
	self.isLaunched = state
	if not state then
		self:removeMember()
		self.fields.Image_arrow:setRotation(SoraDFPosX(90, 0))
		self.fields.Com_show:setVisible(false)
	else
		self:createMember()
		self.fields.Image_arrow:setRotation(0)
		self.fields.Com_show:setVisible(true)
	end
end
function Com_campBuildTitle:createMember(...)
	self.fields.List:setNumItems(#self.objIdList)
	self.fields.List:resizeToFit(#self.objIdList)
	local _fields = fguiHelper.get_fields(self.fields.Com_show)
	_fields.Text_noData:setVisible(#self.objIdList <= 0)
	if #self.objIdList <= 0 then
		self.fields.List:setHeight(60)
	end
	local showH = self.fields.Com_show:getHeight()
	self:setHeight(self.baseHeight + showH)
end
function Com_campBuildTitle:removeMember(...)
	self.fields.List:setNumItems(0)
	self.fields.List:resizeToFit(0)
	self:setHeight(self.baseHeight)
end
return Com_campBuildTitle

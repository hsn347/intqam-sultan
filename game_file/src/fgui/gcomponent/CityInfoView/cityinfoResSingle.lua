local buildRead = include("buildDescribeRead")
local buildLogic = include("buildLogic")
local cityltCtrl = include("cityltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local cityinfoResSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CityInfoView/cityinfoResSingle", cityinfoResSingle)
function cityinfoResSingle:onInit()
	self:addClickListener(handler(self, self.btnClick))
	self:fixChildrenPos()
end
function cityinfoResSingle:onShow()
end
function cityinfoResSingle:initData(resitem)
	self.building = resitem
	self.fields.Image_building:setSpriteFrame(buildRead.getIcon(self.building.bid))
	self.fields.Text_Level:setString(self:reWarLv(self.building.level))
	if resitem.double > 1 then
		self.fields.et_double:setVisible(true)
		buildRead = self:reWarLv(self.building.level)
		self:reWarLv(self.building.level).curval = self.building.curval
		self:reWarLv(self.building.level).addition = fguiHelper.getColorString("#4CE61A", "+" .. self.building.addition)
		self:reWarLv(self.building.level).double = fguiHelper.getColorString("#00FFFF", "x" .. self.building.double)
		self.fields.Text_Des:setString(i18n("(%{curval}%{addition})%{double}/h", self:reWarLv(self.building.level)))
	else
		self.fields.et_double:setVisible(false)
		buildRead = i18n("(%{curval}%{addition})%{double}/h", self:reWarLv(self.building.level))
		i18n("(%{curval}%{addition})%{double}/h", self:reWarLv(self.building.level)).curval = self.building.curval
		i18n("(%{curval}%{addition})%{double}/h", self:reWarLv(self.building.level)).addition = fguiHelper.getColorString("#4CE61A", "+" .. self.building.addition)
		self.fields.Text_Des:setString(i18n("%{curval}%{addition}/h", i18n("(%{curval}%{addition})%{double}/h", self:reWarLv(self.building.level))))
	end
	if tonumber(self.building.updating) == BUILD_STATE.UPGRADEING then
		self.controllers.c1:setSelectedIndex(1)
		local nowCapacity = cityltCtrl.buildLvInfo(self.building.bid, self.building.level, "capacity")
		local toCapacity = cityltCtrl.buildLvInfo(self.building.bid, self.building.level + 1, "capacity")
		self.fields.Text_upgrade:setString(self:reWarLv(self.building.level) .. "      ->      " .. self:reWarLv(self.building.level + 1) .. "\n" .. nowCapacity .. "      ->      " .. toCapacity)
	elseif tonumber(self.building.updating) == BUILD_STATE.DEMOLISHING then
		self.controllers.c1:setSelectedIndex(2)
		buildRead = self:reWarLv(self.building.level) .. "      ->      " .. self:reWarLv(self.building.level + 1) .. "\n" .. nowCapacity .. "      ->      " .. toCapacity
		;(self:reWarLv(self.building.level) .. "      ->      " .. self:reWarLv(self.building.level + 1) .. "\n" .. nowCapacity .. "      ->      " .. toCapacity).level = self:reWarLv(self.building.level)
		;(self:reWarLv(self.building.level) .. "      ->      " .. self:reWarLv(self.building.level + 1) .. "\n" .. nowCapacity .. "      ->      " .. toCapacity).name = buildRead.getName(self.building.bid)
		self.fields.Text_domolishing:setString(i18n("common_text_773", self:reWarLv(self.building.level) .. "      ->      " .. self:reWarLv(self.building.level + 1) .. "\n" .. nowCapacity .. "      ->      " .. toCapacity))
	else
		self.controllers.c1:setSelectedIndex(0)
	end
end
function cityinfoResSingle:reWarLv(level)
	local warLv = buildLogic.transformBuildLvToWarLv(level)
	local reLv = 0
	if 0 < warLv then
		buildLogic = nil
		;(nil).build = ""
		;(nil).lv = warLv
		reLv = i18n("common_text_1957", nil)
	else
		buildLogic = nil
		;(nil).level = level
		reLv = i18n("common_text_600", nil)
	end
	return reLv
end
function cityinfoResSingle:btnClick()
	SoraDPlaySound()
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.delay(0.08333333333333333)
	;(nil)[2] = ffa.callFunc(function()
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD_TIP_HAND"
		;(nil).offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD_TIP_HAND
		;(nil).bid = self.building.bid
		;(nil).iid = self.building.iid
		SoraDSendMessage(nil)
		SoraDRemoveAllPrePanelFromManager(self)
	end)
	;(nil)[3] = ffa.callFunc(function()
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD_TIP_HAND"
		;(nil).offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD_TIP_HAND
		;(nil).bid = self.building.bid
		;(nil).iid = self.building.iid
		SoraDSendMessage(nil)
		SoraDRemoveAllPrePanelFromManager(self)
	end)
	self:runAction(ffa.seq(nil))
end
return cityinfoResSingle

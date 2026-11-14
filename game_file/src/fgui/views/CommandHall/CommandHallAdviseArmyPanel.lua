local buildDescribeRead = include("buildDescribeRead")
local armyDesRead = include("armyDesRead")
local buildLogic = include("buildLogic")
local cityltCtrl = include("cityltCtrl")
local armyLogic = include("armyLogic")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CommandHallAdviseArmyPanel = class("CommandHallAdviseArmyPanel", baseFguiPanel)
function CommandHallAdviseArmyPanel:ctor(...)
	self.super.ctor(self, ...)
	print("CommandHallAdviseArmyPanel:ctor", self.viewName)
	_ENV, _UPVALUE3_ = "CommandHallAdviseArmyPanel:ctor", print
	_ENV, ("CommandHallAdviseArmyPanel:ctor").bid = BUILDID.CHARIOT_PLANT, BUILDID.CHARIOT_PLANT
	_ENV, BUILDID.CHARIOT_PLANT.bid = BUILDID.RANGE, BUILDID.RANGE
	BUILDID.RANGE.bid = BUILDID.STABLES
	self.config, print[1] = print, "CommandHallAdviseArmyPanel:ctor"
	self.config, print[2] = print, BUILDID.CHARIOT_PLANT
	self.config, print[3] = print, BUILDID.RANGE
end
function CommandHallAdviseArmyPanel:onInit()
	print("=======CommandHallAdviseArmyPanel:onInit")
	self.armyLv = self.proxy.param and self.proxy.param.armyLv or 1
	self.fields.Panel_bg:setString(i18n("epicbattle_btn_02"))
	self.fields.List_army:setItemRenderer(handler(self, self.onArmyItemRenderer))
	self.fields.List_army:setNumItems(#self.config)
end
function CommandHallAdviseArmyPanel:onShow()
	print("=======CommandHallAdviseArmyPanel:onShow")
end
function CommandHallAdviseArmyPanel:onArmyItemRenderer(index, obj)
	obj:fixChildrenPos()
	local data = self.config[index + 1]
	local bid = data.bid
	local ui = fguiHelper.get_fields(obj)
	local buildIcon = buildDescribeRead.getIcon(bid)
	ui.Load_icon:setURL(buildIcon)
	local buildName = buildDescribeRead.getName(bid)
	ui.Text_name:setString(buildName)
	local curLv = SoraDGetBuildLv(bid)
	_ENV = nil
	;(nil).lv = buildLogic.getBuildLvStr(curLv)
	ui.Text_lv:setString(i18n("commandhall_text_39", nil))
	local needLv = cityltCtrl.getUnlockedSoldierLv(bid, self.armyLv)
	if curLv >= needLv then
		ui.Text_des:setVisible(false)
	else
		local neeLvStr = buildLogic.getBuildLvStr(needLv)
		local army = armyDesRead.getArmyTpyeName(bid)
		_ENV = i18n("commandhall_text_39", nil)
		i18n("commandhall_text_39", nil).build = buildName
		i18n("commandhall_text_39", nil).lv = neeLvStr
		i18n("commandhall_text_39", nil).army = army
		i18n("commandhall_text_39", nil).num = self.armyLv
		ui.Text_des:setString(i18n("commandhall_text_40", i18n("commandhall_text_39", nil)))
	end
	ui.Button_go:addClickListener(handlerEx(self, self.onClickBtnGo, index))
	ui.Button_go:setString(i18n("common_text_477"))
	ui.Image_light:setVisible(index % 2 ~= 0)
end
function CommandHallAdviseArmyPanel:onClickBtnGo(index, target)
	local data = self.config[index + 1]
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD_TIP_HAND"
	;(nil).offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD_TIP_HAND
	;(nil).bid = data.bid
	SoraDGotoCityBuild(nil)
	SoraDRemoveAllPanelFromManager()
end
return CommandHallAdviseArmyPanel

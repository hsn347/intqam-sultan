local activity_9001736_Ctrl = SoraDGetCtrl("activity_9001736_Ctrl")
local activity_9001736_Read = include("activity_9001736_Read")
local baseComponent = require("fgui.base.baseComponent")
local Com_9001736_Seed = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001736/Com_9001736_Seed", Com_9001736_Seed)
function Com_9001736_Seed:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001736_SELECT_SEED", handler(self, self.onMsgSelectSeed))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001736_UP_LEVEL", handler(self, self.onMsgUpLevel))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001736_RESET_LEVEL", handler(self, self.onMsgResetLevel))
end
function Com_9001736_Seed:onInit()
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001736
	self.seedMaxNum = activity_9001736_Ctrl:getSeedMaxNum()
	self.fields.Button_task:setTitle(i18n("common_text_675"))
	self.fields.Button_task:addClickListener(handler(self, self.onClick_Button_task))
	self.fields.Button_exchange:setTitle(i18n("common_text_1889"))
	self.fields.Button_exchange:addClickListener(handler(self, self.onClick_Button_exchange))
	self.fields.Button_getSeed:setTitle(i18n("football_match_text_024"))
	self.fields.Button_getSeed:addClickListener(handler(self, self.onClick_Button_getSeed))
	self.fields.Button_lvup:setTitle(i18n("football_match_text_022"))
	self.fields.Button_lvup:addClickListener(handler(self, self.onClick_Button_lvup))
	self.fields.Button_edit:setTitle(i18n("football_match_text_023"))
	self.fields.Button_edit:addClickListener(handler(self, self.onClick_Button_edit))
	self.fields.Button_bond:setTitle(i18n("football_match_text_029"))
	self.fields.Button_bond:addClickListener(handler(self, self.onClick_Button_bond))
	self.fields.List_seedCamp:setItemRenderer(handler(self, self.itemRenderer_List_camp))
end
function Com_9001736_Seed:onShow()
	print("Com_9001736_Seed:onShow")
	self:updateBattleSeedInfo()
	self:updateBtnTaskRedDot()
	self:updateBtnExchangeRedDot()
	self:updateBtnGetSeedRedDot()
end
function Com_9001736_Seed:onClick_Button_task(context)
	SoraDPlaySound()
	uiManager:show("Activity_9001736_Task")
end
function Com_9001736_Seed:onClick_Button_exchange(context)
	SoraDPlaySound()
	local commonExchangeUtil = include("commonExchangeUtil")
	commonExchangeUtil.openView(self.activityID)
end
function Com_9001736_Seed:onClick_Button_getSeed(context)
	SoraDPlaySound()
	uiManager:show("Activity_9001736_GetSeed")
end
function Com_9001736_Seed:onClick_Button_lvup(context)
	SoraDPlaySound()
	uiManager:show("Activity_9001736_SeedBag")
end
function Com_9001736_Seed:onClick_Button_edit(context)
	SoraDPlaySound()
	uiManager:show("Activity_9001736_EditSeed")
end
function Com_9001736_Seed:onClick_Button_bond(context)
	SoraDPlaySound()
	local battleSeedList = activity_9001736_Ctrl:getBattleSeedList()
	local maxSeedTypeNum = activity_9001736_Ctrl:getMaxSeedTypeNum(battleSeedList)
	local activiBondIdx = activity_9001736_Read.getBondIdx(maxSeedTypeNum)
	_ENV = nil
	;(nil).activiBondIdx = activiBondIdx
	uiManager:show("Activity_9001736_Bond", nil)
end
function Com_9001736_Seed:itemRenderer_List_camp(index, obj)
	local data = self.seedTypeList[index + 1]
	local _fields = fguiHelper.get_fields(obj)
	local imageName = activity_9001736_Read.getSeedTypeIcon(data.seedType)
	_fields.Image_camp:setURL(imageName)
	local powerStr = "x" .. data.num
	_fields.Text_power:setString(powerStr)
end
function Com_9001736_Seed:onMsgSelectSeed(target, event)
	self:updateBattleSeedInfo()
end
function Com_9001736_Seed:updateBattleSeedInfo()
	self.seedTypeList = activity_9001736_Ctrl:getSeedTypeList()
	self.fields.List_seedCamp:setNumItems(#self.seedTypeList)
	self:updateSeedPower()
	self:updateSeedBond()
end
function Com_9001736_Seed:updateSeedPower()
	local power = activity_9001736_Ctrl:getPower()
	local powerStr = string.formatnumberthousands(power)
	activity_9001736_Ctrl = nil
	;(nil).color = "#FFC864"
	powerStr = SoraDWrapHtmlTagByStyle(powerStr, nil)
	activity_9001736_Ctrl = nil
	;(nil).num = powerStr
	self.fields.Lab_power:setString(i18n("football_match_text_005", nil))
end
function Com_9001736_Seed:updateSeedBond()
	local maxSeedTypeNum = activity_9001736_Ctrl:getMaxSeedTypeNum()
	local powerUp = activity_9001736_Read.getBondPowerUp(maxSeedTypeNum)
	local powerUpStr = string.format("%s%%", tostring(powerUp / 100))
	activity_9001736_Ctrl = tostring(powerUp / 100)
	tostring(powerUp / 100).color = "#70C723"
	powerUpStr = SoraDWrapHtmlTagByStyle(powerUpStr, tostring(powerUp / 100))
	activity_9001736_Ctrl = tostring(powerUp / 100)
	tostring(powerUp / 100).num = powerUpStr
	self.fields.Lab_bond:setString(i18n("football_match_text_083", tostring(powerUp / 100)))
end
function Com_9001736_Seed:onMsgUpLevel(target, event)
	self:updateSeedPower()
end
function Com_9001736_Seed:onMsgResetLevel(target, event)
	self:updateSeedPower()
end
function Com_9001736_Seed:updateBtnTaskRedDot()
	local _isRed, _num = activity_9001736_Ctrl:getAllTaskRedPointAndNum()
	self.fields.Button_task:setReddot(_isRed, _num)
end
function Com_9001736_Seed:updateBtnExchangeRedDot()
	local _isRed, _num = activity_9001736_Ctrl:getExchangeRedPointAndNum()
	self.fields.Button_exchange:setReddot(_isRed, _num)
end
function Com_9001736_Seed:updateBtnGetSeedRedDot()
	local _isRed, _num = activity_9001736_Ctrl:getSeedItemRedPointAndNum()
	self.fields.Button_getSeed:setReddot(_isRed, _num)
end
return Com_9001736_Seed

local sinbadTreasureCtrl = SoraDGetCtrl("sinbadTreasureCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local sinbadTreasureRead = include("sinbadTreasureRead")
local sinbadTreasurePopVew = class("sinbadTreasurePopVew", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("sinbadTreasurePopVew")
	end
	return target
end)
_UPVALUE5_ = "sinbadTreasurePopVew"
;("sinbadTreasurePopVew")[1] = "frame_Sinbad_box_01.png"
;("sinbadTreasurePopVew")[2] = "frame_Sinbad_box_02.png"
;("sinbadTreasurePopVew")[3] = "frame_Sinbad_box_03.png"
;("sinbadTreasurePopVew")[4] = "frame_Sinbad_box_04.png"
local ("sinbadTreasurePopVew")[5], boxImage = "frame_Sinbad_box_05.png", "sinbadTreasurePopVew"
function sinbadTreasurePopVew:ctor()
	self:initWidget()
	self:fitDevice()
	self:initData()
end
function sinbadTreasurePopVew:fitDevice()
	self.Panel_cut:setPositionY(display.height / 2)
end
function sinbadTreasurePopVew:onMessageListener()
end
function sinbadTreasurePopVew:initWidget()
	SoraDGetAllChildFromWidget(self, self)
	self.Text_name:setString(i18n("Sinbad_text_09"))
	self.Button_go:setTitleText(i18n("common_text_1669"))
	self.Button_go:addTouchEventListener(handler(self, self.buttonGetCallBack))
	self.tableMapPiece = SoraDGetChildsArrayByName(self, "bg_map_", 5, 1)
	for i, v in ipairs(self.tableMapPiece) do
		v:setVisible(false)
	end
end
function sinbadTreasurePopVew:initData()
	local activityData = sinbadTreasureCtrl:getActivityData()
	local boxInfo = sinbadTreasureRead.getStageRewardInfo(sinbadTreasureCtrl:getClassType())
	dump(activityData, "slkdjfklsdjflkds111")
	dump(boxInfo, "slkdjfklsdjflkds222")
	if activityData.notifiedKingdomDecorateLv == 0 then
		activityData.notifiedKingdomDecorateLv = 1
	end
	local curBoxInfo = boxInfo[activityData.notifiedKingdomDecorateLv]
	self.Button_box_reward:loadTextures(boxImage[activityData.notifiedKingdomDecorateLv], boxImage[activityData.notifiedKingdomDecorateLv], boxImage[activityData.notifiedKingdomDecorateLv], ccui.TextureResType.plistType)
	sinbadTreasureCtrl = boxImage[activityData.notifiedKingdomDecorateLv]
	boxImage[activityData.notifiedKingdomDecorateLv].var = i18n(curBoxInfo.name)
	self.Text_ins:setString(i18n("Sinbad_text_11", boxImage[activityData.notifiedKingdomDecorateLv]))
	for i, v in ipairs(self.tableMapPiece) do
		v:setVisible(i <= activityData.notifiedKingdomDecorateLv)
	end
end
function sinbadTreasurePopVew:buttonGetCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		clientEventMgr.singleClickEvent(gActivityTimeActivityID.SINBAD_TREASURE)
		self:removeFromParent()
	end
end
function sinbadTreasurePopVew:onExitPanel()
	SoraDDeletePopupWindow(uiDequeTypeTab.SINBADTREASURE)
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:sinbadTreasurePopVew:first~bool", false, nil)
end
return sinbadTreasurePopVew

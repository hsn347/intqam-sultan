local publicRead = include("publicRead")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local constantRead = include("constantRead")
local summerPrayCtrl = SoraDGetCtrl("summerPrayCtrl")
local summerPrayRead = include("summerPrayRead")
local summerPrayersNode = class("summerPrayersNode", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	target = target or SoraDCreateBasePanel("summerPrayersNode")
	SoraDDeviceFitOffset(target)
	return target
end)
local maxGiftNum = 6
_UPVALUE2_, _UPVALUE2_, summerPrayersNode.ctor = nil, function(self, properties)
	self.activityID = gActivityTimeActivityID.SUMMER_PRAY_ACTIVITY
	self.scaleNode = 1
	self.itemID = summerPrayCtrl:getItemID()
	self.nowShowIndex = 0
	self.btnPrayTouch = true
	self.maxResetNum = constantRead.getConstValue("SUMMER_PRAY_MAX_RESET_COUNT", 10)
	self.imageTopBg = SoraDGetChildByName(self, "Image_Bg")
	self.nodeBottom = SoraDGetChildByName(self, "Node_Bottom_Down")
	self.nodeBox = SoraDGetChildByName(self.nodeBottom, "Node_Box")
	self.nodeTop = SoraDGetChildByName(self, "Top_Node_T")
	self.nodeBar = SoraDGetChildByName(self.nodeBottom, "Node_Bar")
	self.nodeDoorEffect = SoraDGetChildByName(self.nodeTop, "Node_Effect")
	self.nodeDoorButton = SoraDGetChildByName(self.nodeTop, "Node_Button")
	self.doorEffectList = SoraDGetChildsArrayByName(self.nodeTop, "Node_", 6, 1, true)
	self.spNameList = SoraDGetChildsArrayByName(self.nodeTop, "Sprite_Name_", 6, 1, true)
	self.doorButtonList = SoraDGetChildsArrayByName(self.nodeDoorButton, "Button_DoorClick_", 6, 1, true)
	self.nodeGiftName = SoraDGetChildByName(self, "Node_GiftName")
	self.nodeGiftNameDown = SoraDGetChildByName(self, "Node_GiftNameDown")
	self.nodeTimer = SoraDGetChildByName(self, "Node_Timer")
	self.textActivityTime = SoraDGetChildByName(self, "Text_ActivityTime")
	self.textActivityTime = SoraDCreateTimerLabel(self, self.textActivityTime)
	self.btnLookPreAward = SoraDGetChildByName(self, "Button_Look")
	self.btnLookPreAward:setTouchEnabled(true)
	self.btnLookPreAward:addTouchEventListener(handler(self, self.btnLookPreAwardClick))
	self.textPreAwardTitle = SoraDGetChildByName(self, "Text_PreAwardTitle")
	self.textPreAwardTitle:setString(i18n("decrypt_text_03"))
	self.btnReset = SoraDGetChildByName(self, "Button_Reset")
	self.btnReset:setTouchEnabled(true)
	self.btnReset:setTitleText(i18n("common_text_4152"))
	self.btnReset:addTouchEventListener(handler(self, self.btnResetClick))
	self.textResetTime = SoraDGetChildByName(self.btnReset, "Text_ResetTime")
	self.lBarInter = SoraDGetChildByName(self, "LoadingBar_inter")
	self.effectBar = SoraDGetChildByName(self.lBarInter, "Panel_Sheer")
	self.textBarDes = SoraDGetChildByName(self.lBarInter, "Text_barDes")
	self.textBF1 = SoraDGetChildByName(self.lBarInter, "BitmapFontLabel_1")
	self.textLuckyNum = SoraDGetChildByName(self.lBarInter, "Text_LuckyNum")
	self.textLuckyNum:setString(i18n("pray_text_07"))
	self.imageIconBox = SoraDGetChildByName(self, "Image_IconBox")
	self.btnBox = SoraDGetChildByName(self, "Button_Box")
	self.btnBox = include("commonBtnInstance").new(self.btnBox)
	self.textBoxName = SoraDGetChildByName(self, "Text_BoxName")
	self.textTips = SoraDGetChildByName(self, "Text_Tips")
	self.btnPrayer = SoraDGetChildByName(self, "Button_Prayer")
	self.btnPrayer:setSwallowTouches(true)
	self.btnPrayer:addTouchEventListener(handlerEx(self, self.btnPrayerClick, 1))
	self.nodePray = SoraDGetChildByName(self, "Node_BtnPray")
	self.textPray = SoraDGetChildByName(self, "Text_Pray")
	self.btnPrayerTen = SoraDGetChildByName(self, "Button_PrayerTen")
	self.btnPrayerTen:setSwallowTouches(true)
	self.btnPrayerTen:addTouchEventListener(handlerEx(self, self.btnPrayerClick, 10))
	SoraDGetChildByName(self.btnPrayerTen, "Text_1"):setString(_p("10"))
	SoraDGetChildByName(self.btnPrayerTen, "Text_Pray"):setString(i18n("pray_text_23"))
	SoraDToCenter(SoraDGetChildByName(self.btnPrayerTen, "Node_BtnPray"), 5, not SoraDFIsRA())
	self.nodeNum = SoraDGetChildByName(self, "Node_Num")
	self.textNumDescribe = SoraDGetChildByName(self, "Text_NumDescribe")
	self.textNumDescribe:setString(i18n("palace_text_19"))
	self.textNumHave = SoraDGetChildByName(self, "Text_NumHave")
	self.btnAdd = SoraDGetChildByName(self, "Button_Add")
	self.btnAdd:setTouchEnabled(true)
	self.btnAdd:addTouchEventListener(handler(self, self.btnAddClick))
	self.nodeEndTips = SoraDGetChildByName(self, "Center_Node_bg")
	self.nodeEndTips:setVisible(false)
	SoraDGetChildByName(self.nodeEndTips, "Panel_Black"):setContentSize(cc.size(640, display.height))
	self.textExplain = SoraDGetChildByName(self, "Text_Explain")
	self.textExplain:setString(i18n("pray_text_17"))
	self.leftLightFrame = SoraDGetChildByName(self, "bg_cxqf_zbty_Left")
	self.rightLightFrame = SoraDGetChildByName(self, "bg_cxqf_ybty_Right")
	self:initActivityTime()
	self:fitView()
	self:initEffect()
	self:initData()
end, function(self, properties)
	self.activityID = gActivityTimeActivityID.SUMMER_PRAY_ACTIVITY
	self.scaleNode = 1
	self.itemID = summerPrayCtrl:getItemID()
	self.nowShowIndex = 0
	self.btnPrayTouch = true
	self.maxResetNum = constantRead.getConstValue("SUMMER_PRAY_MAX_RESET_COUNT", 10)
	self.imageTopBg = SoraDGetChildByName(self, "Image_Bg")
	self.nodeBottom = SoraDGetChildByName(self, "Node_Bottom_Down")
	self.nodeBox = SoraDGetChildByName(self.nodeBottom, "Node_Box")
	self.nodeTop = SoraDGetChildByName(self, "Top_Node_T")
	self.nodeBar = SoraDGetChildByName(self.nodeBottom, "Node_Bar")
	self.nodeDoorEffect = SoraDGetChildByName(self.nodeTop, "Node_Effect")
	self.nodeDoorButton = SoraDGetChildByName(self.nodeTop, "Node_Button")
	self.doorEffectList = SoraDGetChildsArrayByName(self.nodeTop, "Node_", 6, 1, true)
	self.spNameList = SoraDGetChildsArrayByName(self.nodeTop, "Sprite_Name_", 6, 1, true)
	self.doorButtonList = SoraDGetChildsArrayByName(self.nodeDoorButton, "Button_DoorClick_", 6, 1, true)
	self.nodeGiftName = SoraDGetChildByName(self, "Node_GiftName")
	self.nodeGiftNameDown = SoraDGetChildByName(self, "Node_GiftNameDown")
	self.nodeTimer = SoraDGetChildByName(self, "Node_Timer")
	self.textActivityTime = SoraDGetChildByName(self, "Text_ActivityTime")
	self.textActivityTime = SoraDCreateTimerLabel(self, self.textActivityTime)
	self.btnLookPreAward = SoraDGetChildByName(self, "Button_Look")
	self.btnLookPreAward:setTouchEnabled(true)
	self.btnLookPreAward:addTouchEventListener(handler(self, self.btnLookPreAwardClick))
	self.textPreAwardTitle = SoraDGetChildByName(self, "Text_PreAwardTitle")
	self.textPreAwardTitle:setString(i18n("decrypt_text_03"))
	self.btnReset = SoraDGetChildByName(self, "Button_Reset")
	self.btnReset:setTouchEnabled(true)
	self.btnReset:setTitleText(i18n("common_text_4152"))
	self.btnReset:addTouchEventListener(handler(self, self.btnResetClick))
	self.textResetTime = SoraDGetChildByName(self.btnReset, "Text_ResetTime")
	self.lBarInter = SoraDGetChildByName(self, "LoadingBar_inter")
	self.effectBar = SoraDGetChildByName(self.lBarInter, "Panel_Sheer")
	self.textBarDes = SoraDGetChildByName(self.lBarInter, "Text_barDes")
	self.textBF1 = SoraDGetChildByName(self.lBarInter, "BitmapFontLabel_1")
	self.textLuckyNum = SoraDGetChildByName(self.lBarInter, "Text_LuckyNum")
	self.textLuckyNum:setString(i18n("pray_text_07"))
	self.imageIconBox = SoraDGetChildByName(self, "Image_IconBox")
	self.btnBox = SoraDGetChildByName(self, "Button_Box")
	self.btnBox = include("commonBtnInstance").new(self.btnBox)
	self.textBoxName = SoraDGetChildByName(self, "Text_BoxName")
	self.textTips = SoraDGetChildByName(self, "Text_Tips")
	self.btnPrayer = SoraDGetChildByName(self, "Button_Prayer")
	self.btnPrayer:setSwallowTouches(true)
	self.btnPrayer:addTouchEventListener(handlerEx(self, self.btnPrayerClick, 1))
	self.nodePray = SoraDGetChildByName(self, "Node_BtnPray")
	self.textPray = SoraDGetChildByName(self, "Text_Pray")
	self.btnPrayerTen = SoraDGetChildByName(self, "Button_PrayerTen")
	self.btnPrayerTen:setSwallowTouches(true)
	self.btnPrayerTen:addTouchEventListener(handlerEx(self, self.btnPrayerClick, 10))
	SoraDGetChildByName(self.btnPrayerTen, "Text_1"):setString(_p("10"))
	SoraDGetChildByName(self.btnPrayerTen, "Text_Pray"):setString(i18n("pray_text_23"))
	SoraDToCenter(SoraDGetChildByName(self.btnPrayerTen, "Node_BtnPray"), 5, not SoraDFIsRA())
	self.nodeNum = SoraDGetChildByName(self, "Node_Num")
	self.textNumDescribe = SoraDGetChildByName(self, "Text_NumDescribe")
	self.textNumDescribe:setString(i18n("palace_text_19"))
	self.textNumHave = SoraDGetChildByName(self, "Text_NumHave")
	self.btnAdd = SoraDGetChildByName(self, "Button_Add")
	self.btnAdd:setTouchEnabled(true)
	self.btnAdd:addTouchEventListener(handler(self, self.btnAddClick))
	self.nodeEndTips = SoraDGetChildByName(self, "Center_Node_bg")
	self.nodeEndTips:setVisible(false)
	SoraDGetChildByName(self.nodeEndTips, "Panel_Black"):setContentSize(cc.size(640, display.height))
	self.textExplain = SoraDGetChildByName(self, "Text_Explain")
	self.textExplain:setString(i18n("pray_text_17"))
	self.leftLightFrame = SoraDGetChildByName(self, "bg_cxqf_zbty_Left")
	self.rightLightFrame = SoraDGetChildByName(self, "bg_cxqf_ybty_Right")
	self:initActivityTime()
	self:fitView()
	self:initEffect()
	self:initData()
end
_UPVALUE2_, (nil)[1] = 149, 149
_UPVALUE2_, (nil)[2] = 149, 137
;(149)[1] = 228
;(149)[2] = 236
;(function(self, properties)
	self.activityID = gActivityTimeActivityID.SUMMER_PRAY_ACTIVITY
	self.scaleNode = 1
	self.itemID = summerPrayCtrl:getItemID()
	self.nowShowIndex = 0
	self.btnPrayTouch = true
	self.maxResetNum = constantRead.getConstValue("SUMMER_PRAY_MAX_RESET_COUNT", 10)
	self.imageTopBg = SoraDGetChildByName(self, "Image_Bg")
	self.nodeBottom = SoraDGetChildByName(self, "Node_Bottom_Down")
	self.nodeBox = SoraDGetChildByName(self.nodeBottom, "Node_Box")
	self.nodeTop = SoraDGetChildByName(self, "Top_Node_T")
	self.nodeBar = SoraDGetChildByName(self.nodeBottom, "Node_Bar")
	self.nodeDoorEffect = SoraDGetChildByName(self.nodeTop, "Node_Effect")
	self.nodeDoorButton = SoraDGetChildByName(self.nodeTop, "Node_Button")
	self.doorEffectList = SoraDGetChildsArrayByName(self.nodeTop, "Node_", 6, 1, true)
	self.spNameList = SoraDGetChildsArrayByName(self.nodeTop, "Sprite_Name_", 6, 1, true)
	self.doorButtonList = SoraDGetChildsArrayByName(self.nodeDoorButton, "Button_DoorClick_", 6, 1, true)
	self.nodeGiftName = SoraDGetChildByName(self, "Node_GiftName")
	self.nodeGiftNameDown = SoraDGetChildByName(self, "Node_GiftNameDown")
	self.nodeTimer = SoraDGetChildByName(self, "Node_Timer")
	self.textActivityTime = SoraDGetChildByName(self, "Text_ActivityTime")
	self.textActivityTime = SoraDCreateTimerLabel(self, self.textActivityTime)
	self.btnLookPreAward = SoraDGetChildByName(self, "Button_Look")
	self.btnLookPreAward:setTouchEnabled(true)
	self.btnLookPreAward:addTouchEventListener(handler(self, self.btnLookPreAwardClick))
	self.textPreAwardTitle = SoraDGetChildByName(self, "Text_PreAwardTitle")
	self.textPreAwardTitle:setString(i18n("decrypt_text_03"))
	self.btnReset = SoraDGetChildByName(self, "Button_Reset")
	self.btnReset:setTouchEnabled(true)
	self.btnReset:setTitleText(i18n("common_text_4152"))
	self.btnReset:addTouchEventListener(handler(self, self.btnResetClick))
	self.textResetTime = SoraDGetChildByName(self.btnReset, "Text_ResetTime")
	self.lBarInter = SoraDGetChildByName(self, "LoadingBar_inter")
	self.effectBar = SoraDGetChildByName(self.lBarInter, "Panel_Sheer")
	self.textBarDes = SoraDGetChildByName(self.lBarInter, "Text_barDes")
	self.textBF1 = SoraDGetChildByName(self.lBarInter, "BitmapFontLabel_1")
	self.textLuckyNum = SoraDGetChildByName(self.lBarInter, "Text_LuckyNum")
	self.textLuckyNum:setString(i18n("pray_text_07"))
	self.imageIconBox = SoraDGetChildByName(self, "Image_IconBox")
	self.btnBox = SoraDGetChildByName(self, "Button_Box")
	self.btnBox = include("commonBtnInstance").new(self.btnBox)
	self.textBoxName = SoraDGetChildByName(self, "Text_BoxName")
	self.textTips = SoraDGetChildByName(self, "Text_Tips")
	self.btnPrayer = SoraDGetChildByName(self, "Button_Prayer")
	self.btnPrayer:setSwallowTouches(true)
	self.btnPrayer:addTouchEventListener(handlerEx(self, self.btnPrayerClick, 1))
	self.nodePray = SoraDGetChildByName(self, "Node_BtnPray")
	self.textPray = SoraDGetChildByName(self, "Text_Pray")
	self.btnPrayerTen = SoraDGetChildByName(self, "Button_PrayerTen")
	self.btnPrayerTen:setSwallowTouches(true)
	self.btnPrayerTen:addTouchEventListener(handlerEx(self, self.btnPrayerClick, 10))
	SoraDGetChildByName(self.btnPrayerTen, "Text_1"):setString(_p("10"))
	SoraDGetChildByName(self.btnPrayerTen, "Text_Pray"):setString(i18n("pray_text_23"))
	SoraDToCenter(SoraDGetChildByName(self.btnPrayerTen, "Node_BtnPray"), 5, not SoraDFIsRA())
	self.nodeNum = SoraDGetChildByName(self, "Node_Num")
	self.textNumDescribe = SoraDGetChildByName(self, "Text_NumDescribe")
	self.textNumDescribe:setString(i18n("palace_text_19"))
	self.textNumHave = SoraDGetChildByName(self, "Text_NumHave")
	self.btnAdd = SoraDGetChildByName(self, "Button_Add")
	self.btnAdd:setTouchEnabled(true)
	self.btnAdd:addTouchEventListener(handler(self, self.btnAddClick))
	self.nodeEndTips = SoraDGetChildByName(self, "Center_Node_bg")
	self.nodeEndTips:setVisible(false)
	SoraDGetChildByName(self.nodeEndTips, "Panel_Black"):setContentSize(cc.size(640, display.height))
	self.textExplain = SoraDGetChildByName(self, "Text_Explain")
	self.textExplain:setString(i18n("pray_text_17"))
	self.leftLightFrame = SoraDGetChildByName(self, "bg_cxqf_zbty_Left")
	self.rightLightFrame = SoraDGetChildByName(self, "bg_cxqf_ybty_Right")
	self:initActivityTime()
	self:fitView()
	self:initEffect()
	self:initData()
end)[1] = nil
local (function(self, properties)
	self.activityID = gActivityTimeActivityID.SUMMER_PRAY_ACTIVITY
	self.scaleNode = 1
	self.itemID = summerPrayCtrl:getItemID()
	self.nowShowIndex = 0
	self.btnPrayTouch = true
	self.maxResetNum = constantRead.getConstValue("SUMMER_PRAY_MAX_RESET_COUNT", 10)
	self.imageTopBg = SoraDGetChildByName(self, "Image_Bg")
	self.nodeBottom = SoraDGetChildByName(self, "Node_Bottom_Down")
	self.nodeBox = SoraDGetChildByName(self.nodeBottom, "Node_Box")
	self.nodeTop = SoraDGetChildByName(self, "Top_Node_T")
	self.nodeBar = SoraDGetChildByName(self.nodeBottom, "Node_Bar")
	self.nodeDoorEffect = SoraDGetChildByName(self.nodeTop, "Node_Effect")
	self.nodeDoorButton = SoraDGetChildByName(self.nodeTop, "Node_Button")
	self.doorEffectList = SoraDGetChildsArrayByName(self.nodeTop, "Node_", 6, 1, true)
	self.spNameList = SoraDGetChildsArrayByName(self.nodeTop, "Sprite_Name_", 6, 1, true)
	self.doorButtonList = SoraDGetChildsArrayByName(self.nodeDoorButton, "Button_DoorClick_", 6, 1, true)
	self.nodeGiftName = SoraDGetChildByName(self, "Node_GiftName")
	self.nodeGiftNameDown = SoraDGetChildByName(self, "Node_GiftNameDown")
	self.nodeTimer = SoraDGetChildByName(self, "Node_Timer")
	self.textActivityTime = SoraDGetChildByName(self, "Text_ActivityTime")
	self.textActivityTime = SoraDCreateTimerLabel(self, self.textActivityTime)
	self.btnLookPreAward = SoraDGetChildByName(self, "Button_Look")
	self.btnLookPreAward:setTouchEnabled(true)
	self.btnLookPreAward:addTouchEventListener(handler(self, self.btnLookPreAwardClick))
	self.textPreAwardTitle = SoraDGetChildByName(self, "Text_PreAwardTitle")
	self.textPreAwardTitle:setString(i18n("decrypt_text_03"))
	self.btnReset = SoraDGetChildByName(self, "Button_Reset")
	self.btnReset:setTouchEnabled(true)
	self.btnReset:setTitleText(i18n("common_text_4152"))
	self.btnReset:addTouchEventListener(handler(self, self.btnResetClick))
	self.textResetTime = SoraDGetChildByName(self.btnReset, "Text_ResetTime")
	self.lBarInter = SoraDGetChildByName(self, "LoadingBar_inter")
	self.effectBar = SoraDGetChildByName(self.lBarInter, "Panel_Sheer")
	self.textBarDes = SoraDGetChildByName(self.lBarInter, "Text_barDes")
	self.textBF1 = SoraDGetChildByName(self.lBarInter, "BitmapFontLabel_1")
	self.textLuckyNum = SoraDGetChildByName(self.lBarInter, "Text_LuckyNum")
	self.textLuckyNum:setString(i18n("pray_text_07"))
	self.imageIconBox = SoraDGetChildByName(self, "Image_IconBox")
	self.btnBox = SoraDGetChildByName(self, "Button_Box")
	self.btnBox = include("commonBtnInstance").new(self.btnBox)
	self.textBoxName = SoraDGetChildByName(self, "Text_BoxName")
	self.textTips = SoraDGetChildByName(self, "Text_Tips")
	self.btnPrayer = SoraDGetChildByName(self, "Button_Prayer")
	self.btnPrayer:setSwallowTouches(true)
	self.btnPrayer:addTouchEventListener(handlerEx(self, self.btnPrayerClick, 1))
	self.nodePray = SoraDGetChildByName(self, "Node_BtnPray")
	self.textPray = SoraDGetChildByName(self, "Text_Pray")
	self.btnPrayerTen = SoraDGetChildByName(self, "Button_PrayerTen")
	self.btnPrayerTen:setSwallowTouches(true)
	self.btnPrayerTen:addTouchEventListener(handlerEx(self, self.btnPrayerClick, 10))
	SoraDGetChildByName(self.btnPrayerTen, "Text_1"):setString(_p("10"))
	SoraDGetChildByName(self.btnPrayerTen, "Text_Pray"):setString(i18n("pray_text_23"))
	SoraDToCenter(SoraDGetChildByName(self.btnPrayerTen, "Node_BtnPray"), 5, not SoraDFIsRA())
	self.nodeNum = SoraDGetChildByName(self, "Node_Num")
	self.textNumDescribe = SoraDGetChildByName(self, "Text_NumDescribe")
	self.textNumDescribe:setString(i18n("palace_text_19"))
	self.textNumHave = SoraDGetChildByName(self, "Text_NumHave")
	self.btnAdd = SoraDGetChildByName(self, "Button_Add")
	self.btnAdd:setTouchEnabled(true)
	self.btnAdd:addTouchEventListener(handler(self, self.btnAddClick))
	self.nodeEndTips = SoraDGetChildByName(self, "Center_Node_bg")
	self.nodeEndTips:setVisible(false)
	SoraDGetChildByName(self.nodeEndTips, "Panel_Black"):setContentSize(cc.size(640, display.height))
	self.textExplain = SoraDGetChildByName(self, "Text_Explain")
	self.textExplain:setString(i18n("pray_text_17"))
	self.leftLightFrame = SoraDGetChildByName(self, "bg_cxqf_zbty_Left")
	self.rightLightFrame = SoraDGetChildByName(self, "bg_cxqf_ybty_Right")
	self:initActivityTime()
	self:fitView()
	self:initEffect()
	self:initData()
end)[2], pos = 149, function(self, properties)
	self.activityID = gActivityTimeActivityID.SUMMER_PRAY_ACTIVITY
	self.scaleNode = 1
	self.itemID = summerPrayCtrl:getItemID()
	self.nowShowIndex = 0
	self.btnPrayTouch = true
	self.maxResetNum = constantRead.getConstValue("SUMMER_PRAY_MAX_RESET_COUNT", 10)
	self.imageTopBg = SoraDGetChildByName(self, "Image_Bg")
	self.nodeBottom = SoraDGetChildByName(self, "Node_Bottom_Down")
	self.nodeBox = SoraDGetChildByName(self.nodeBottom, "Node_Box")
	self.nodeTop = SoraDGetChildByName(self, "Top_Node_T")
	self.nodeBar = SoraDGetChildByName(self.nodeBottom, "Node_Bar")
	self.nodeDoorEffect = SoraDGetChildByName(self.nodeTop, "Node_Effect")
	self.nodeDoorButton = SoraDGetChildByName(self.nodeTop, "Node_Button")
	self.doorEffectList = SoraDGetChildsArrayByName(self.nodeTop, "Node_", 6, 1, true)
	self.spNameList = SoraDGetChildsArrayByName(self.nodeTop, "Sprite_Name_", 6, 1, true)
	self.doorButtonList = SoraDGetChildsArrayByName(self.nodeDoorButton, "Button_DoorClick_", 6, 1, true)
	self.nodeGiftName = SoraDGetChildByName(self, "Node_GiftName")
	self.nodeGiftNameDown = SoraDGetChildByName(self, "Node_GiftNameDown")
	self.nodeTimer = SoraDGetChildByName(self, "Node_Timer")
	self.textActivityTime = SoraDGetChildByName(self, "Text_ActivityTime")
	self.textActivityTime = SoraDCreateTimerLabel(self, self.textActivityTime)
	self.btnLookPreAward = SoraDGetChildByName(self, "Button_Look")
	self.btnLookPreAward:setTouchEnabled(true)
	self.btnLookPreAward:addTouchEventListener(handler(self, self.btnLookPreAwardClick))
	self.textPreAwardTitle = SoraDGetChildByName(self, "Text_PreAwardTitle")
	self.textPreAwardTitle:setString(i18n("decrypt_text_03"))
	self.btnReset = SoraDGetChildByName(self, "Button_Reset")
	self.btnReset:setTouchEnabled(true)
	self.btnReset:setTitleText(i18n("common_text_4152"))
	self.btnReset:addTouchEventListener(handler(self, self.btnResetClick))
	self.textResetTime = SoraDGetChildByName(self.btnReset, "Text_ResetTime")
	self.lBarInter = SoraDGetChildByName(self, "LoadingBar_inter")
	self.effectBar = SoraDGetChildByName(self.lBarInter, "Panel_Sheer")
	self.textBarDes = SoraDGetChildByName(self.lBarInter, "Text_barDes")
	self.textBF1 = SoraDGetChildByName(self.lBarInter, "BitmapFontLabel_1")
	self.textLuckyNum = SoraDGetChildByName(self.lBarInter, "Text_LuckyNum")
	self.textLuckyNum:setString(i18n("pray_text_07"))
	self.imageIconBox = SoraDGetChildByName(self, "Image_IconBox")
	self.btnBox = SoraDGetChildByName(self, "Button_Box")
	self.btnBox = include("commonBtnInstance").new(self.btnBox)
	self.textBoxName = SoraDGetChildByName(self, "Text_BoxName")
	self.textTips = SoraDGetChildByName(self, "Text_Tips")
	self.btnPrayer = SoraDGetChildByName(self, "Button_Prayer")
	self.btnPrayer:setSwallowTouches(true)
	self.btnPrayer:addTouchEventListener(handlerEx(self, self.btnPrayerClick, 1))
	self.nodePray = SoraDGetChildByName(self, "Node_BtnPray")
	self.textPray = SoraDGetChildByName(self, "Text_Pray")
	self.btnPrayerTen = SoraDGetChildByName(self, "Button_PrayerTen")
	self.btnPrayerTen:setSwallowTouches(true)
	self.btnPrayerTen:addTouchEventListener(handlerEx(self, self.btnPrayerClick, 10))
	SoraDGetChildByName(self.btnPrayerTen, "Text_1"):setString(_p("10"))
	SoraDGetChildByName(self.btnPrayerTen, "Text_Pray"):setString(i18n("pray_text_23"))
	SoraDToCenter(SoraDGetChildByName(self.btnPrayerTen, "Node_BtnPray"), 5, not SoraDFIsRA())
	self.nodeNum = SoraDGetChildByName(self, "Node_Num")
	self.textNumDescribe = SoraDGetChildByName(self, "Text_NumDescribe")
	self.textNumDescribe:setString(i18n("palace_text_19"))
	self.textNumHave = SoraDGetChildByName(self, "Text_NumHave")
	self.btnAdd = SoraDGetChildByName(self, "Button_Add")
	self.btnAdd:setTouchEnabled(true)
	self.btnAdd:addTouchEventListener(handler(self, self.btnAddClick))
	self.nodeEndTips = SoraDGetChildByName(self, "Center_Node_bg")
	self.nodeEndTips:setVisible(false)
	SoraDGetChildByName(self.nodeEndTips, "Panel_Black"):setContentSize(cc.size(640, display.height))
	self.textExplain = SoraDGetChildByName(self, "Text_Explain")
	self.textExplain:setString(i18n("pray_text_17"))
	self.leftLightFrame = SoraDGetChildByName(self, "bg_cxqf_zbty_Left")
	self.rightLightFrame = SoraDGetChildByName(self, "bg_cxqf_ybty_Right")
	self:initActivityTime()
	self:fitView()
	self:initEffect()
	self:initData()
end
function summerPrayersNode:initEffect()
	local ret = _G.SoraDIsFileExistByKey("summerPrayFA")
	if ret then
		display.addSpriteFrames("Common/summerPrayFA.plist", getImageFileNameByPlatform("Common/summerPrayFA"))
	end
	_UPVALUE2_ = getImageFileNameByPlatform("Common/summerPrayFA")
	getImageFileNameByPlatform("Common/summerPrayFA")[1] = cca.scaleTo(0, 1.05)
	getImageFileNameByPlatform("Common/summerPrayFA")[2] = cca.scaleTo(0.16666666666666666, 1.0417)
	getImageFileNameByPlatform("Common/summerPrayFA")[3] = cca.scaleTo(0.3333333333333333, 1)
	getImageFileNameByPlatform("Common/summerPrayFA")[4] = cca.scaleTo(0.3333333333333333, 1)
	getImageFileNameByPlatform("Common/summerPrayFA")[5] = cca.scaleTo(0.3333333333333333, 1)
	getImageFileNameByPlatform("Common/summerPrayFA")[6] = cca.scaleTo(0.3333333333333333, 1)
	getImageFileNameByPlatform("Common/summerPrayFA")[7] = cca.scaleTo(0.3333333333333333, 1)
	getImageFileNameByPlatform("Common/summerPrayFA")[8] = cca.scaleTo(0.3333333333333333, 1)
	SoraDGetChildByName(self, "bg_cxqf_bjt2"):runAction(cca.seq(getImageFileNameByPlatform("Common/summerPrayFA")))
	_UPVALUE2_ = cca.seq(getImageFileNameByPlatform("Common/summerPrayFA"))
	cca.seq(getImageFileNameByPlatform("Common/summerPrayFA"))[1] = cca.scaleTo(0, 1.1)
	cca.seq(getImageFileNameByPlatform("Common/summerPrayFA"))[2] = cca.scaleTo(0.16666666666666666, 1.0833)
	cca.seq(getImageFileNameByPlatform("Common/summerPrayFA"))[3] = cca.scaleTo(0.3333333333333333, 1)
	cca.seq(getImageFileNameByPlatform("Common/summerPrayFA"))[4] = cca.scaleTo(0.3333333333333333, 1)
	cca.seq(getImageFileNameByPlatform("Common/summerPrayFA"))[5] = cca.scaleTo(0.3333333333333333, 1)
	cca.seq(getImageFileNameByPlatform("Common/summerPrayFA"))[6] = cca.scaleTo(0.3333333333333333, 1)
	cca.seq(getImageFileNameByPlatform("Common/summerPrayFA"))[7] = cca.scaleTo(0.3333333333333333, 1)
	cca.seq(getImageFileNameByPlatform("Common/summerPrayFA"))[8] = cca.scaleTo(0.3333333333333333, 1)
	SoraDGetChildByName(self, "Node_qiang"):runAction(cca.seq(cca.seq(getImageFileNameByPlatform("Common/summerPrayFA"))))
	SoraDGetChildByName(self.nodeBox, "Image_7"):setScale(1.14)
	_UPVALUE1_ = cca.seq(cca.seq(getImageFileNameByPlatform("Common/summerPrayFA")))
	cca.seq(cca.seq(getImageFileNameByPlatform("Common/summerPrayFA")))[1] = cca.scaleTo(0.16666666666666666, 1.1167)
	cca.seq(cca.seq(getImageFileNameByPlatform("Common/summerPrayFA")))[2] = cca.scaleTo(0.3333333333333333, 1)
	cca.seq(cca.seq(getImageFileNameByPlatform("Common/summerPrayFA")))[3] = cca.scaleTo(0.3333333333333333, 1)
	cca.seq(cca.seq(getImageFileNameByPlatform("Common/summerPrayFA")))[4] = cca.scaleTo(0.3333333333333333, 1)
	cca.seq(cca.seq(getImageFileNameByPlatform("Common/summerPrayFA")))[5] = cca.scaleTo(0.3333333333333333, 1)
	cca.seq(cca.seq(getImageFileNameByPlatform("Common/summerPrayFA")))[6] = cca.scaleTo(0.3333333333333333, 1)
	cca.seq(cca.seq(getImageFileNameByPlatform("Common/summerPrayFA")))[7] = cca.scaleTo(0.3333333333333333, 1)
	cca.seq(cca.seq(getImageFileNameByPlatform("Common/summerPrayFA")))[8] = cca.scaleTo(0.3333333333333333, 1)
	SoraDGetChildByName(self.nodeBox, "Image_7"):runAction(cca.seq(cca.seq(cca.seq(getImageFileNameByPlatform("Common/summerPrayFA")))))
	_UPVALUE8_ = SoraDGetChildByName(self.nodeBox, "Image_7").runAction
	SoraDGetChildByName(self.nodeBox, "Image_7").runAction[1] = self.nodeTop
	SoraDGetChildByName(self.nodeBox, "Image_7").runAction[2] = self.nodeBar
	SoraDGetChildByName(self.nodeBox, "Image_7").runAction[3] = self.nodeNum
	SoraDGetChildByName(self.nodeBox, "Image_7").runAction[4] = self.btnPrayer
	SoraDGetChildByName(self.nodeBox, "Image_7").runAction[5] = self.btnPrayerTen
	SoraDGetChildByName(self.nodeBox, "Image_7").runAction[6] = self.leftLightFrame
	SoraDGetChildByName(self.nodeBox, "Image_7").runAction[7] = self.rightLightFrame
	SoraDGetChildByName(self.nodeBox, "Image_7").runAction[8] = SoraDGetChildByName(self.nodeBox, "Node_ItemAward")
	SoraDGetChildByName(self.nodeBox, "Image_7").runAction[9] = SoraDGetChildByName(self.nodeBox, "Node_Tips")
	SoraDGetChildByName(self.nodeBox, "Image_7").runAction[10] = SoraDGetChildByName(self.nodeBox, "Node_Tips")
	local SoraDGetChildByName(self.nodeBox, "Image_7").runAction[11], actionNodeArray = SoraDGetChildByName(self.nodeBox, "Node_Tips")
	for _, v in ipairs(actionNodeArray) do
		self:runActionFadeto(v)
	end
	local cssFileName = "summerPrayersNode"
	local cssFilePath = getCCSPath(cssFileName)
	local action = cc.CSLoader:createTimeline(cssFilePath)
	action:gotoFrameAndPlay(0, true)
	self:runAction(action)
end
function summerPrayersNode:runActionFadeto(target)
	target:setOpacity(0)
	_UPVALUE1_ = nil
	;(nil)[1] = cca.delay(0.3333333333333333)
	;(nil)[2] = cca.fadeTo(0.5, 1)
	;(nil)[3] = cca.fadeTo(0.5, 1)
	;(nil)[4] = cca.fadeTo(0.5, 1)
	target:runAction(cca.seq(nil))
end
function summerPrayersNode:onEnterPanel()
	summerPrayCtrl:reqSummerPrayInit()
end
function summerPrayersNode:onExitPanel()
	if self.lBarInter.lBarInter then
		SoraDManagerRemoveTimer(self.lBarInter, self.lBarInter.loadingBarTimer)
		self.lBarInter.loadingBarTimer = nil
	end
end
function summerPrayersNode:fitView()
	local heightOffset = 0
	local x_T = self.nodeTop:getPositionY() - 1070
	local x_D = self.nodeTop:getPositionY() - 980
	if x_T < 0 and x_D < 0 then
		heightOffset = math.max(x_T, x_D)
	else
		heightOffset = math.min(0, x_T)
	end
	local posYOffset = math.min(170, -heightOffset)
	if display.height < 900 then
		self.scaleNode = 0.7
		self.nodeBottom:setScale(0.7)
		SoraDGetChildByName(self.nodeBottom, "Image_sheer"):setScale(1.4285)
		posYOffset = posYOffset + 100
	else
		local posYBoxOffset = math.max(0, 100 - posYOffset)
		self.nodeBox:setPositionY(217 + posYBoxOffset)
		self.nodeBar:setPositionY(self.nodeBar:getPositionY() + posYBoxOffset / 2)
		self.nodeNum:setPositionY(self.nodeNum:getPositionY() + math.min(10, posYBoxOffset / 4))
	end
	local posYDown = 1062 - posYOffset - self.nodeTop:getPositionY()
	local posYTop = 1070 - posYOffset - self.nodeTop:getPositionY()
	local posYNodeEffect = 648 - posYOffset - self.nodeTop:getPositionY()
	print("posYOffset", self.nodeTop:getPositionY(), posYOffset, posYTop, heightOffset)
	self.imageTopBg:setPositionY(-posYOffset)
	self.nodeGiftName:setPositionY(math.min(35, posYTop))
	self.nodeGiftNameDown:setPositionY(posYDown)
	if SoraDFIsRA() and 35 < posYTop then
		SoraDGetChildByName(self, "Sprite_Name_1"):setPositionX(145 + 0.2545454545454545 * (posYTop - 35))
		SoraDGetChildByName(self, "Sprite_Name_3"):setPositionX(-147 - 0.34545454545454546 * (posYTop - 35))
	elseif 35 < posYTop then
		SoraDGetChildByName(self, "Sprite_Name_1"):setPositionX(-142 - 0.34545454545454546 * (posYTop - 35))
		SoraDGetChildByName(self, "Sprite_Name_3"):setPositionX(145 + 0.2545454545454545 * (posYTop - 35))
	end
	self.nodeDoorEffect:setPositionY(posYNodeEffect)
	self.nodeDoorButton:setPositionY(posYNodeEffect)
end
function summerPrayersNode:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateItemNums))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.updateViewState))
	SoraDAddMessage(self, "MESSAGE_SUMMER_PRAY_VIEW", handler(self, self.msgCallBack))
end
function summerPrayersNode:initData(target, data)
	SoraDCloseLoading(self)
	self.boxOrder = summerPrayCtrl:getGiftOrder()
	self.haveResetNum = summerPrayCtrl:getResetPrayCount()
	self.luckyNum = summerPrayCtrl:getPrayValue()
	local config = summerPrayRead.getBoxConfigByOrder(self.boxOrder + 1)
	self.maxLuckyNum = tonumber(config.praypoint)
	self.textBoxName:setString(i18n(publicRead.getName(config.packreward1[1].id)))
	self.imageIconBox:loadTexture(publicRead.getIcon(config.packreward1[1].id), ccui.TextureResType.plistType)
	self.btnBox:setItemInfo(self, config.packreward1[1].id, config.packreward1[1].count)
	self:updateItemNums()
	self:updateLoadBar()
	_ENV = config.packreward1[1].id
	config.packreward1[1].id.activityID = self.activityID
	self:updateViewState(nil, config.packreward1[1].id)
	self.btnBox:setTouchShowTips(true)
	if summerPrayCtrl:getIsFirst() then
		self.textTips:setString(i18n("pray_text_24"))
		self.textPray:setString(i18n("pray_text_09"))
		self.btnPrayerTen:setVisible(false)
		self.btnPrayer:setPositionX(0)
		SoraDGetChildByName(self, "Text_1"):setString(" ")
		SoraDRechargeBtnEffect(self.btnPrayer, 1.7, 3)
	else
		if self.itemNums >= 10 then
			self.btnPrayerTen:setVisible(true)
			self.btnPrayer:setPositionX(SoraDFPosX(-160, 0))
		else
			self.btnPrayer:setPositionX(0)
			self.btnPrayerTen:setVisible(false)
		end
		_ENV = SoraDFPosX(-160, 0)
		SoraDFPosX(-160, 0).num = config.praypoint
		self.textTips:setString(i18n("pray_text_06", SoraDFPosX(-160, 0)))
		SoraDGetChildByName(self, "Text_1"):setString(_p("1"))
		self.textPray:setString(i18n("pray_text_23"))
		local sprite = self.btnPrayer:getChildByName("effect_recharge_button")
		if sprite then
			sprite:removeFromParent()
		end
	end
	SoraDToCenter(self.nodePray, 5, not SoraDFIsRA())
	SoraDAutoSizeButtonText(self.btnReset, cc.size(78, 36))
end
function summerPrayersNode:initActivityTime()
	self.eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	self.textActivityTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("pray_text_21", nil)
	end)
	if self.eventTime then
		self.textActivityTime:beginTime(self.eventTime.timerNode.timer:getRemainTime())
	end
	SoraDToCenter(self.nodeTimer, 10, not SoraDFIsRA())
end
_UPVALUE6_, summerPrayersNode.updateItemNums = function(self)
	self.itemNums = backpackCtrl:getItemCount(self.itemID)
	self.textNumHave:setString(self.itemNums)
	SoraDToCenter(self.nodeNum, 10, SoraDFIsRA())
end, function(self)
	self.itemNums = backpackCtrl:getItemCount(self.itemID)
	self.textNumHave:setString(self.itemNums)
	SoraDToCenter(self.nodeNum, 10, SoraDFIsRA())
end
;(function(self)
	self.itemNums = backpackCtrl:getItemCount(self.itemID)
	self.textNumHave:setString(self.itemNums)
	SoraDToCenter(self.nodeNum, 10, SoraDFIsRA())
end)[1] = "frame_cxqf_jx"
;(function(self)
	self.itemNums = backpackCtrl:getItemCount(self.itemID)
	self.textNumHave:setString(self.itemNums)
	SoraDToCenter(self.nodeNum, 10, SoraDFIsRA())
end)[2] = "frame_cxqf_jk"
;(function(self)
	self.itemNums = backpackCtrl:getItemCount(self.itemID)
	self.textNumHave:setString(self.itemNums)
	SoraDToCenter(self.nodeNum, 10, SoraDFIsRA())
end)[3] = "frame_cxqf_xf"
;(function(self)
	self.itemNums = backpackCtrl:getItemCount(self.itemID)
	self.textNumHave:setString(self.itemNums)
	SoraDToCenter(self.nodeNum, 10, SoraDFIsRA())
end)[4] = "frame_cxqf_da"
;(function(self)
	self.itemNums = backpackCtrl:getItemCount(self.itemID)
	self.textNumHave:setString(self.itemNums)
	SoraDToCenter(self.nodeNum, 10, SoraDFIsRA())
end)[5] = "frame_cxqf_pa"
local (function(self)
	self.itemNums = backpackCtrl:getItemCount(self.itemID)
	self.textNumHave:setString(self.itemNums)
	SoraDToCenter(self.nodeNum, 10, SoraDFIsRA())
end)[6], nameConfig = "frame_cxqf_xw", function(self)
	self.itemNums = backpackCtrl:getItemCount(self.itemID)
	self.textNumHave:setString(self.itemNums)
	SoraDToCenter(self.nodeNum, 10, SoraDFIsRA())
end
function summerPrayersNode:updateLoadBar()
	if self.luckyNum == 0 then
		self.textBF1:setString(self.luckyNum)
		self.lBarInter:setPercent(0)
		self.effectBar:setContentSize(cc.size(0, 25))
		SoraDGetChildByName(self.effectBar, "Node_BarEffect"):setPositionX(SoraDFPosX(0, 0))
	elseif self.lBarInter:getPercent() ~= self.luckyNum / self.maxLuckyNum * 100 then
		SoraDLoadingBarAction(self.lBarInter, 100, function(percent)
			print("percent", percent)
			self:barEffectHead(percent)
			if percent == 100 then
				self.textBF1:setString(self.luckyNum)
				self.lBarInter:setPercent(0)
				self.effectBar:setContentSize(cc.size(0, 25))
				SoraDLoadingBarAction(self.lBarInter, self.luckyNum / self.maxLuckyNum * 100, handler(self, self.barEffectHead))
			end
		end)
	end
	_ENV = SoraDFPosX(0, 0)
	SoraDFPosX(0, 0).count = self.maxResetNum - self.haveResetNum
	self.textResetTime:setString(i18n("exchange_columntext_01", SoraDFPosX(0, 0)))
	self.textResetTime:setColor(self.maxResetNum == self.haveResetNum and cc.c3b(255, 0, 0) or cc.c3b(255, 255, 255))
	for i, v in ipairs(self.spNameList) do
		local frameName = nameConfig[i] .. (i <= self.boxOrder and "2" or "") .. (SoraDFIsRA() and "_ar" or "_en") .. ".png"
		v:setSpriteFrame(frameName)
		print("self.boxOrder", self.boxOrder)
		self.doorEffectList[i]:setVisible(i <= self.boxOrder)
		SoraDGetChildByName(self.doorEffectList[i], "Node_DoorEffect"):setVisible(true)
		if self.doorEffectList[self.boxOrder + 1] then
			self.doorEffectList[self.boxOrder + 1]:setVisible(true)
			SoraDGetChildByName(self.doorEffectList[self.boxOrder + 1], "Node_DoorEffect"):setVisible(false)
			SoraDGetChildByName(self.doorEffectList[self.boxOrder + 1], "dh_qifu2_New"):setVisible(true)
		end
		local leftFrameVisible = SoraDFIsRA() and self.boxOrder >= 6 or not SoraDFIsRA() and self.boxOrder >= 4
		local rightFrameVisible = SoraDFIsRA() and self.boxOrder >= 4 or not SoraDFIsRA() and self.boxOrder >= 6
		self.leftLightFrame:setVisible(leftFrameVisible)
		self.rightLightFrame:setVisible(rightFrameVisible)
		if self.nowShowIndex == i then
			self.nowShowIndex = 0
			SoraDGetChildByName(self.doorEffectList[i], "Node_DoorEffect"):setVisible(true)
			self.doorEffectList[i]:setOpacity(0)
			nameConfig = i18n("exchange_columntext_01", SoraDFPosX(0, 0))
			i18n("exchange_columntext_01", SoraDFPosX(0, 0))[1] = cca.delay(0.08333333333333333)
			i18n("exchange_columntext_01", SoraDFPosX(0, 0))[2] = cca.fadeTo(1, 1)
			i18n("exchange_columntext_01", SoraDFPosX(0, 0))[3] = cca.fadeTo(1, 1)
			i18n("exchange_columntext_01", SoraDFPosX(0, 0))[4] = cca.fadeTo(1, 1)
			self.doorEffectList[i]:runAction(cca.seq(i18n("exchange_columntext_01", SoraDFPosX(0, 0))))
			if SoraDFIsRA() and i == 6 or not SoraDFIsRA() and i == 4 then
				self.leftLightFrame:setOpacity(0)
				nameConfig = cca.seq(i18n("exchange_columntext_01", SoraDFPosX(0, 0)))
				cca.seq(i18n("exchange_columntext_01", SoraDFPosX(0, 0)))[1] = cca.delay(0.08333333333333333)
				cca.seq(i18n("exchange_columntext_01", SoraDFPosX(0, 0)))[2] = cca.fadeTo(1, 1)
				cca.seq(i18n("exchange_columntext_01", SoraDFPosX(0, 0)))[3] = cca.fadeTo(1, 1)
				cca.seq(i18n("exchange_columntext_01", SoraDFPosX(0, 0)))[4] = cca.fadeTo(1, 1)
				self.leftLightFrame:runAction(cca.seq(cca.seq(i18n("exchange_columntext_01", SoraDFPosX(0, 0)))))
			end
			if SoraDFIsRA() and i == 4 or not SoraDFIsRA() and i == 6 then
				self.rightLightFrame:setOpacity(0)
				nameConfig = cca.seq(cca.seq(i18n("exchange_columntext_01", SoraDFPosX(0, 0))))
				cca.seq(cca.seq(i18n("exchange_columntext_01", SoraDFPosX(0, 0))))[1] = cca.delay(0.08333333333333333)
				cca.seq(cca.seq(i18n("exchange_columntext_01", SoraDFPosX(0, 0))))[2] = cca.fadeTo(1, 1)
				cca.seq(cca.seq(i18n("exchange_columntext_01", SoraDFPosX(0, 0))))[3] = cca.fadeTo(1, 1)
				cca.seq(cca.seq(i18n("exchange_columntext_01", SoraDFPosX(0, 0))))[4] = cca.fadeTo(1, 1)
				self.rightLightFrame:runAction(cca.seq(cca.seq(cca.seq(i18n("exchange_columntext_01", SoraDFPosX(0, 0))))))
			end
		end
		self.doorButtonList[i]:addTouchEventListener(handlerEx(self, self.btnDoorClick, i))
	end
end
function summerPrayersNode:barEffectHead(percent)
	self.effectBar:setContentSize(cc.size(percent / 100 * 360, 25))
	SoraDGetChildByName(self.effectBar, "Node_BarEffect"):setPositionX(SoraDFPosX(0, percent / 100 * 360))
end
function summerPrayersNode:btnLookPreAwardClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		local panel = SoraDCreatePanel("summerPrayersPreAwardView")
		panel:show()
	end
end
function summerPrayersNode:btnResetClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		if self.haveResetNum == self.maxResetNum and self.boxOrder ~= maxGiftNum then
			SoraDShowMsgTip(i18n("pray_text_19"))
		else
			SoraDShowMsgBox(i18n("pray_text_18"), i18n("common_text_204"), nil, function(type)
				if MSGBOX_CALLBACK_YES == type then
					self:resetPray()
				end
			end)
		end
	end
end
function summerPrayersNode:resetPray()
	summerPrayCtrl:reqSummerPrayReset()
end
function summerPrayersNode:btnPrayerClick(num, target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		print("lth--------btnPrayerClick")
		if not self.btnPrayTouch then
			return
		end
		if self.itemNums <= 0 and not summerPrayCtrl:getIsFirst() then
			SoraDShowMsgBox(i18n("pray_text_15"), i18n("common_text_204"), nil, handler(self, self.openShopView))
		elseif self.boxOrder == maxGiftNum then
			local panel = SoraDCreatePanel("summerPrayersPopReset")
			_ENV = handler(self, self.openShopView)
			handler(self, self.openShopView).yes = i18n("common_text_204")
			handler(self, self.openShopView).tips = i18n("pray_text_20")
			handler(self, self.openShopView).view = self
			panel:initData(nil, handler(self, self.openShopView))
			panel:show()
		else
			self.btnPrayTouch = false
			if num == 1 then
				summerPrayCtrl:reqSummerPrayBless()
			else
				summerPrayCtrl:reqSummerPrayBlessTen()
			end
		end
	end
end
function summerPrayersNode:btnAddClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:openShopView(MSGBOX_CALLBACK_YES)
	end
end
function summerPrayersNode:btnDoorClick(index, target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("summerPrayersDoorClickView")
		panel:initData(index)
		panel:show()
	end
end
function summerPrayersNode:openShopView(type)
	if MSGBOX_CALLBACK_YES == type then
		uiManager:show("summerPrayersShop")
	end
end
function summerPrayersNode:msgCallBack(target, data)
	if data.subMsg == "bless" then
		print("lth--------blessBack")
		local panel
		if not data.isTen then
			if data.success then
				panel = SoraDCreatePanel("summerPrayersSuccessView")
				self.nowShowIndex = self.boxOrder + 1
				if data.reward then
					_ENV = nil
					;(nil).packreward = data.reward
					;(nil).successItem = data.successItem
					panel:initData(nil)
					panel:panelScaleAct()
					panel:show()
				end
			else
				SoraDShowMsgTip(i18n("pray_text_16"))
				SoraDMailGainItems(data.reward, true)
				self:initData()
			end
		else
			dump(data.reward, "reward")
			if data.success then
				panel = SoraDCreatePanel("summerPrayersSuccessView")
				panel:initTenData(data.reward)
				panel:panelScaleAct()
				panel:show()
			else
				SoraDShowMsgTip(i18n("pray_text_16"))
				SoraDMailGainItems(data.reward, true)
				self:initData()
			end
		end
		_UPVALUE1_ = i18n("pray_text_16")
		i18n("pray_text_16")[1] = cca.delay(1)
		i18n("pray_text_16")[2] = cca.callFunc(function()
			self.btnPrayTouch = true
		end)
		i18n("pray_text_16")[3] = cca.callFunc(function()
			self.btnPrayTouch = true
		end)
		self:runAction(cca.seq(i18n("pray_text_16")))
	else
		SoraDCloseLoading(self.parentView)
		self:initData()
	end
end
function summerPrayersNode:updateViewState(target, data)
	if data.activityID == self.activityID then
		local activityData = activityShowCtrl:getActivityData(self.activityID)
		self.showEffect = (activityData.doStage or 0) == 0
		self.nodeBottom:setVisible(self.showEffect)
		self.nodeTop:setVisible(self.showEffect)
		self.nodeEndTips:setVisible(not self.showEffect)
	end
end
return summerPrayersNode

local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local allianceDesRead = include("allianceDesRead")
local warTreasureRead = include("warTreasureRead")
local publicRead = include("publicRead")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local warTreasureCtrl = SoraDGetCtrl("warTreasureCtrl")
local warTreasureCheerPop = class("warTreasureCheerPop", function(target)
	return target or SoraDCreateTouchPanel("warTreasureCheerPop")
end)
function warTreasureCheerPop:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox")
	self.itemUseSlider = SoraDGetExtendChildFromCCSByName(self, "CCS_commonSlider_slider")
	self.nodeInfo = SoraDGetChildByName(self, "Node_Info")
	self.nodeFlag = SoraDGetChildByName(self.nodeInfo, "Node_flag")
	self.textAlliance = SoraDGetChildByName(self, "Text_Alliance")
	self.nowHurt = SoraDGetChildByName(self, "Text_Hurt")
	self.nextHurt = SoraDGetChildByName(self, "Text_UpHurt")
	self.needNextNum = SoraDGetChildByName(self, "Text_UpNeed")
	self.needNextTitle = SoraDGetChildByName(self, "Text_UpNeed_Title")
	self.needNextTitle:setString(i18n("warSecrit_text_09"))
	self.nextImgIcon = SoraDGetChildByName(self.nodeInfo, "Image_Icon")
	self.nodeHave = SoraDGetChildByName(self, "Node_Have")
	self.imageIcon = SoraDGetChildByName(self.nodeHave, "Image_Icon")
	self.textHaveTitle = SoraDGetChildByName(self.nodeHave, "Text_Have_Title")
	self.textHave = SoraDGetChildByName(self.nodeHave, "Text_Have")
	self.btnJumpAllian = SoraDGetChildByName(self, "Button_Jump")
	self.btnConfirm = SoraDGetChildByName(self, "Button_confirm")
	self.btnConfirm:setTitleText(i18n("warSecrit_btn_04"))
	self.maxNum = 0
	self.itemID = 0
	self.btnConfirm:addTouchEventListener(handler(self, self.btnClickSendCheer))
	self.btnJumpAllian:addTouchEventListener(handler(self, self.btnClickJumpAllian))
	self.itemUseSlider:setSliderCallBack(handler(self, self.sliderCallBack))
end
function warTreasureCheerPop:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
end
function warTreasureCheerPop:initData(data, itemID)
	self.chooseAid = data.aid
	self.itemID = itemID
	self.itemType = self.itemID == 827101 and gWorldTypeServerDef.subMapTypeWarTreasureDrum or gWorldTypeServerDef.subMapTypeWarTreasureMedicine
	dump(data, "arTreasureCheerPop:ini", 10)
	_ENV = nil
	;(nil).abbr = data.abbr
	;(nil).name = data.name
	self.textAlliance:setString(i18n("common_text_186", nil))
	self.ccs_bg:setTitleName(i18n(self.itemType == gWorldTypeServerDef.subMapTypeWarTreasureDrum and "warSecrit_btn_01" or "warSecrit_btn_03"))
	self.maxNum = backpackCtrl:getItemCount(self.itemID)
	local allianceHave = self.itemType == gWorldTypeServerDef.subMapTypeWarTreasureDrum and data.drumNum or data.medicineNum
	local buff, lv = warTreasureRead.getBuffByTypeAndNum(self.itemType, allianceHave)
	_ENV = gWorldTypeServerDef.subMapTypeWarTreasureDrum
	gWorldTypeServerDef.subMapTypeWarTreasureDrum.num = buff / 10 .. "%"
	self.nowHurt:setString(i18n(self.itemType == gWorldTypeServerDef.subMapTypeWarTreasureDrum and "warSecrit_text_07" or "warSecrit_text_13", gWorldTypeServerDef.subMapTypeWarTreasureDrum))
	local nextBuff, nextNeedNum = warTreasureRead.getNextBuffByLv(self.itemType, lv + 1)
	if nextBuff then
		_ENV = gWorldTypeServerDef.subMapTypeWarTreasureDrum
		gWorldTypeServerDef.subMapTypeWarTreasureDrum.num = nextBuff / 10 .. "%"
		self.nextHurt:setString(i18n("warSecrit_text_08") .. "\n" .. i18n(self.itemType == gWorldTypeServerDef.subMapTypeWarTreasureDrum and "warSecrit_text_07" or "warSecrit_text_13", gWorldTypeServerDef.subMapTypeWarTreasureDrum))
		_ENV = i18n(self.itemType == gWorldTypeServerDef.subMapTypeWarTreasureDrum and "warSecrit_text_07" or "warSecrit_text_13", gWorldTypeServerDef.subMapTypeWarTreasureDrum)
		i18n(self.itemType == gWorldTypeServerDef.subMapTypeWarTreasureDrum and "warSecrit_text_07" or "warSecrit_text_13", gWorldTypeServerDef.subMapTypeWarTreasureDrum).member = allianceHave
		i18n(self.itemType == gWorldTypeServerDef.subMapTypeWarTreasureDrum and "warSecrit_text_07" or "warSecrit_text_13", gWorldTypeServerDef.subMapTypeWarTreasureDrum).total = nextNeedNum
		self.needNextNum:setString(i18n("common_text_155", (i18n(self.itemType == gWorldTypeServerDef.subMapTypeWarTreasureDrum and "warSecrit_text_07" or "warSecrit_text_13", gWorldTypeServerDef.subMapTypeWarTreasureDrum))))
	else
		self.nextHurt:setVisible(false)
		self.needNextNum:setVisible(false)
		self.needNextTitle:setVisible(false)
		self.nextImgIcon:setVisible(false)
	end
	_ENV = false
	;(false).maxValue = self.maxNum
	;(false).minValue = 0
	;(false).curValue = 0
	self.itemUseSlider:initData(false)
	self.curCount = 1
	self.nodeFlag:removeAllChildren()
	self.nodeFlag = allianceDesRead.getFlagWithParticle(data.flag, self.nodeFlag)
	_ENV = gWorldTypeServerDef.subMapTypeWarTreasureDrum
	gWorldTypeServerDef.subMapTypeWarTreasureDrum.num = ""
	self.textHaveTitle:setString(i18n(self.itemType == gWorldTypeServerDef.subMapTypeWarTreasureDrum and "warSecrit_text_05" or "warSecrit_text_11", gWorldTypeServerDef.subMapTypeWarTreasureDrum))
	self.imageIcon:loadTexture(publicRead.getIcon(self.itemID), ccui.TextureResType.plistType)
	self.nextImgIcon:loadTexture(publicRead.getIcon(self.itemID), ccui.TextureResType.plistType)
	self.textHave:setString(string.formatnumberthousands(self.maxNum))
	SoraDToCenter(self.nodeHave, 10, SoraDFIsRA())
end
function warTreasureCheerPop:sliderCallBack(value)
	self.btnConfirm:setBright(0 < value)
	self.btnConfirm:setTouchEnabled(0 < value)
	self.curCount = 0 < value and value or 0
end
function warTreasureCheerPop:btnClickSendCheer(button, type)
	if type == ccui.TouchEventType.ended then
		_ENV = nil
		;(nil).aid = self.chooseAid
		;(nil).type = self.itemType
		;(nil).num = self.curCount
		warTreasureCtrl:reqWarTreasureDonate(nil)
		self:close(self, type)
	end
end
function warTreasureCheerPop:btnClickJumpAllian(button, type)
	if type == ccui.TouchEventType.ended then
		local gametop = gModuleMgr.getObject("gametop")
		local allianceQuery = gametop.playertop_:getModule("allianceQuery")
		local kid = gametop.playertop_:getKingdomID()
		_ENV = nil
		;(nil).from = "warTreasureCheerPop"
		allianceQuery:reqAllianceInfo(kid, self.chooseAid, nil)
	end
end
function warTreasureCheerPop:sMsgReqInfoBack(target, data)
	print("请求查看联盟信息回来了")
	local alliance = data.alliance
	if data.clientData then
		local from = data.clientData.from
		if from == "warTreasureCheerPop" then
			local kid = alliance:getProperty("sourceKid")
			SoraDOpenAllianceInfoView(alliance, kid)
		end
	end
end
return warTreasureCheerPop

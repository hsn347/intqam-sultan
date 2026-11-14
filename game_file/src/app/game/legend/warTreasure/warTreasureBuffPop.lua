local warTreasureCtrl = SoraDGetCtrl("warTreasureCtrl")
local warTreasureRead = include("warTreasureRead")
local warTreasureBuffPop = class("warTreasureBuffPop", function(target)
	return target or SoraDCreateTouchPanel("warTreasureBuffPop")
end)
function warTreasureBuffPop:ctor()
	self.popBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.popBox:setTitleName(i18n("warSecrit_text_30"))
	self.singleNode_1 = SoraDGetChildByName(self, "Node_Single")
	self.singleNode_1:setTag(1)
	self.singleNode_2 = SoraDGetChildByName(self, "Node_Single_0")
	self.singleNode_2:setTag(2)
	warTreasureCtrl:reqWarTreasureData()
end
function warTreasureBuffPop:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_WAR_TREASURE_REFRESH", handler(self, self.updataData))
end
function warTreasureBuffPop:updataData(target, data)
	if data.subMsg == "init" then
		local haveDrum = warTreasureCtrl:getWarTreasureDrumNum()
		local haveVuln = warTreasureCtrl:getWarTreasureMedicineNum()
		local buff_1, lv_1 = warTreasureRead.getBuffByTypeAndNum(1, haveDrum)
		local buff_2, lv_2 = warTreasureRead.getBuffByTypeAndNum(2, haveVuln)
		warTreasureCtrl = nil
		;(nil).buff = buff_1
		;(nil).lv = lv_1
		self:refreshSingle(self.singleNode_1, nil)
		warTreasureCtrl = nil
		;(nil).buff = buff_2
		;(nil).lv = lv_2
		self:refreshSingle(self.singleNode_2, nil)
	end
end
function warTreasureBuffPop:refreshSingle(target, data)
	local imageIcon = SoraDGetChildByName(target, "Image_Icon")
	local textBuffTitle = SoraDGetChildByName(target, "Text_Buff_Title")
	local textBuff = SoraDGetChildByName(target, "Text_Buff")
	local tag = target:getTag()
	_ENV = nil
	;(nil).num = data.lv
	local strNum = i18n(tag == 2 and "warSecrit_text_41" or "warSecrit_text_40", nil)
	_ENV = data.lv
	data.lv.num = data.buff / 10 .. "%"
	local strBuff = i18n(tag == 2 and "warSecrit_text_13" or "warSecrit_text_07", data.lv)
	textBuffTitle:setString(strNum)
	textBuff:setString(strBuff)
end
return warTreasureBuffPop

local gametop = gModuleMgr.getObject("gametop")
local epicWarCtrl = gametop.playertop_:getModule("epicWarCtrl")
local epicWarltCtrl = include("epicWarltCtrl")
local epicWarGateAwardView = class("epicWarGateAwardView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("epicWarGateAwardView")
	end
	return target
end)
function epicWarGateAwardView:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("epic_war_stageBox_title"))
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Text_tip:setString(i18n("worldcup_text_02"))
	self.Button_receive = SoraDGetChildByName(self, "Button_receive")
	self.Button_receive:setTitleText(i18n("common_text_1146"))
	self.Button_receive:addTouchEventListener(handler(self, self.onBtnCallBack))
	self.Node_item = SoraDGetChildByName(self, "Node_item")
end
function epicWarGateAwardView:initData(gateID)
	self.stageId = gateID
	local award = epicWarltCtrl.getGateBoxCfg(self.stageId)
	epicWarCtrl = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local itemList = serviceFunctions.tableFormat(award, nil)
	for k, v in ipairs(itemList) do
		local item = include("commonItemAward").new()
		item:setOwnView(self)
		item:initData(v.id, v.count)
		item:setScale(0.8)
		item:setBaseScale(1.0)
		item:setPosition(0, 0)
		item:addTo(self.Node_item)
	end
	SoraDautoSortPos(self.Node_item, 5, SoraDFIsRA() and 2 or 0, cc.size(100, 100))
	local isPass = epicWarCtrl:isGatePassed(self.stageId)
	self.Button_receive:setBright(isPass)
	self.Button_receive:setEnabled(isPass)
end
function epicWarGateAwardView:onBtnCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		epicWarCtrl:sendRecieveStageReward(self.stageId)
		self:removeFromParent()
	end
end
return epicWarGateAwardView

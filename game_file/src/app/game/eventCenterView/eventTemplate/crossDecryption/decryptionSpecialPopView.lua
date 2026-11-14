local gametop = gModuleMgr.getObject("gametop")
local crossDecryptionCtrl = gametop.playertop_:getModule("crossDecryptionCtrl")
local crossDecryptionRead = include("crossDecryptionRead")
local decryptionSpecialPopView = class("decryptionSpecialPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("decryptionSpecialPopView")
	end
	return target
end)
function decryptionSpecialPopView:ctor()
	self.text_title = SoraDGetChildByName(self, "Text_title")
	self.text_tips = SoraDGetChildByName(self, "Text_tips")
	self.node_rewards = SoraDGetChildByName(self, "Node_award")
	self.btn_receive = SoraDGetChildByName(self, "Button_gain")
	self.btn_receive:addTouchEventListener(handler(self, self.btnOperateClick))
	self.text_title:setString(i18n("devilvalley_text_27"))
	self.text_tips:setString(i18n("decrypt_text_01"))
	self.btn_receive:setTitleText(i18n("common_text_1146"))
end
function decryptionSpecialPopView:initData(index, ctrl, crossDecryptionRead)
	self.curIndex = index
	ctrl = {}
	self.bigRewardData = crossDecryptionRead.getBigReward(crossDecryptionCtrl:getActivityType())
	for k, v in ipairs(self.bigRewardData) do
		local single = SoraDCreatePanel("commonItemAward")
		single:addTo(self.node_rewards)
		single:setOwnView(self)
		single:setScale(0.8)
		single:setBaseScale(1.0)
		local pos = -230 + k * 90
		if SoraDFIsRA() then
			pos = 230 - k * 100
		end
		single:setPositionX(pos)
		local posY = math.floor(k / 5) - 15
		if display.height - 960 > 0 then
			posY = math.floor(k / 5) + 15
		end
		single:setPositionY(posY)
		single:initData(v.id, v.count)
	end
end
function decryptionSpecialPopView:btnOperateClick(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).index = self.curIndex
		crossDecryptionCtrl:reqGetReward(nil)
		self:removeFromParent()
	end
end
return decryptionSpecialPopView

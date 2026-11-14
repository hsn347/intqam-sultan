local guardianCtrl = SoraDGetCtrl("guardianCtrl")
local premiumStoreCtrl = SoraDGetCtrl("premiumStoreCtrl")
local exaltedPrivilegeCtrl = SoraDGetCtrl("exaltedPrivilegeCtrl")
local publicRead = include("publicRead")
local exclusiveVipRead = include("exclusiveVipRead")
local exclusiveScorePopView = class("exclusiveScorePopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("exclusiveScorePopView")
	end
	return target
end)
function exclusiveScorePopView:ctor()
	self:initControls()
	self:initScroll()
end
function exclusiveScorePopView:onMessageListener()
end
function exclusiveScorePopView:initControls()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("privilege_text_07"))
	self.nodeSingle = SoraDGetChildByName(self, "nodeSingle")
	self.scroll = SoraDGetChildByName(self, "ScrollView_1")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createSingle))
end
function exclusiveScorePopView:initScroll()
	local scoreList = exclusiveVipRead:getVipScoreList()
	dump(scoreList, "scoreList===")
	self.scroll:updateScrollView(cc.size(516, 120), scoreList)
end
function exclusiveScorePopView:createSingle()
	local ocx = self.nodeSingle:clone()
	local txtName = SoraDGetChildByName(ocx, "txtName")
	local btnIntegral = SoraDGetChildByName(ocx, "btnIntegral")
	btnIntegral:setSwallowTouches(false)
	btnIntegral:addTouchEventListener(handler(self, self.btnIntegralClick))
	btnIntegral:setTitleText(i18n("kingdom_grace_btn_01"))
	function ocx.initData(target, data, otherData)
		local numScore = 0
		local loginDays = guardianCtrl:getLoginDay()
		local totalRecharge = premiumStoreCtrl:getDollor()
		if data.type == gExaltedScoreType.LOGIN_DAY then
			SoraDSetTextWidthHeight(txtName, cc.size(460, 60))
			btnIntegral:setVisible(false)
			numScore = exaltedPrivilegeCtrl:getLoginScore()
			guardianCtrl = cc.size(460, 60)
			cc.size(460, 60).day = data.amount
			cc.size(460, 60).point = data.grade
			txtName:setString(i18n("privilege_text_08", cc.size(460, 60)))
		elseif data.type == gExaltedScoreType.ITEM_SCORE then
			SoraDSetTextWidthHeight(txtName, cc.size(460, 60))
			btnIntegral:setVisible(false)
			numScore = exaltedPrivilegeCtrl:getItemScore()
			guardianCtrl = cc.size(460, 60)
			cc.size(460, 60).point = data.grade
			txtName:setString(i18n("privilege_text_11", cc.size(460, 60)))
		elseif data.type == gExaltedScoreType.RECHARGE_VALUE then
			SoraDSetTextWidthHeight(txtName, cc.size(300, 60))
			btnIntegral:setVisible(true)
			numScore = exaltedPrivilegeCtrl:getRechargeScore()
			guardianCtrl = cc.size(300, 60)
			cc.size(300, 60).price = data.amount
			cc.size(300, 60).point = data.grade
			txtName:setString(i18n("privilege_text_13", cc.size(300, 60)))
		end
	end
	return ocx
end
function exclusiveScorePopView:btnIntegralClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if GLOBAL_GAME_RECHARGE_MODE then
			uiManager:show("rechargeView")
		else
			SoraDCreatePanel("rechargeView"):show()
		end
		self:removeFromParent()
	end
end
return exclusiveScorePopView

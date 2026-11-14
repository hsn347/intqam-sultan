local gametop = gModuleMgr.getObject("gametop")
local merchantOfSericaCtrl = SoraDGetCtrl("merchantOfSericaCtrl")
local merchantOfSericaRead = include("merchantOfSericaRead")
local merchantOfSericaGet = class("merchantOfSericaGet", function(target)
	if target == nil then
		target = "Node_Serica_Get"
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(getCCSPath(target))
	end
	return target
end)
function merchantOfSericaGet:ctor()
	self.havaItem = false
	self.CCS_commonItemAward = SoraDGetExtendChildFromCCSByName(self, "CCS_commonItemAward")
	self.Button_clear = SoraDGetChildByName(self, "Button_clear")
	self.Button_item = SoraDGetChildByName(self, "Button_item")
	self.Node_1 = SoraDGetChildByName(self, "Node_1")
	self.Node_particle = SoraDGetChildByName(self.CCS_commonItemAward, "Node_particle")
	SoraDStopEffectNode(self.Node_particle)
	self.CCS_commonItemAward:setVisible(false)
	self.Button_clear:addTouchEventListener(handler(self, self.OnBtnClickClear))
	self.Button_item:addTouchEventListener(handler(self, self.OnBtnClick))
	self:showOrHide(false)
	SoraDCreatAnimation("Node_Serica_Get", self, true)
end
function merchantOfSericaGet:initWithData(data)
	self.getId = SoraDFIsRA() and 5 - data.data or data.data
	self.havaItem = false
	local item = merchantOfSericaCtrl:getSelectById(self.getId)
	local num = merchantOfSericaRead.getNumById(item, merchantOfSericaCtrl:getServerGroup())
	num = num and num or 0
	local done = merchantOfSericaCtrl:getSelectById(self.getId)
	local flag = merchantOfSericaCtrl:getServerFlag()
	self.pView = data.view
	self.CCS_commonItemAward:setOwnView(self.pView)
	self:showOrHide(false)
	if not flag then
		if item then
			self:showOrHide(true)
			self.havaItem = true
			self.CCS_commonItemAward:initData(item, num)
			self.CCS_commonItemAward:setVisible(true)
			self.CCS_commonItemAward:setRealScale(1)
		end
	else
		print("已经购买")
		local id = merchantOfSericaCtrl:getGetListById(self.getId)
		num = merchantOfSericaRead.getNumById(id, merchantOfSericaCtrl:getServerGroup())
		if id then
			self:showOrHide(true)
			self.havaItem = true
			self.CCS_commonItemAward:initData(id, num)
			self.Button_clear:setVisible(false)
			self.CCS_commonItemAward:setVisible(true)
			self.CCS_commonItemAward:setRealScale(1)
		end
	end
end
function merchantOfSericaGet:showOrHide(flag)
	self.Node_1:setVisible(flag)
	self.CCS_commonItemAward:setVisible(flag)
	self.Button_clear:setVisible(flag)
	self.Button_item:setVisible(not flag)
end
function merchantOfSericaGet:OnBtnClickClear(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.havaItem then
			SoraDPlaySound()
			merchantOfSericaCtrl:delSelectByid(self.getId)
		end
	end
end
function merchantOfSericaGet:OnBtnClick(target, event)
	local flag = merchantOfSericaCtrl:getServerFlag()
	if event == ccui.TouchEventType.ended and not flag then
		print("点击盘子", self.getId)
		SoraDPlaySound()
		if not self.havaItem then
			SoraDShowMsgTip(i18n("serica_text_03"))
		end
	end
end
return merchantOfSericaGet

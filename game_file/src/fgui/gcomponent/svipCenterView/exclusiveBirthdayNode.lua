local baseComponent = require("fgui.base.baseComponent")
local exclusiveBirthdayNode = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://svipCenterView/exclusiveBirthdayNode", exclusiveBirthdayNode)
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local honorBackCtrl = SoraDGetCtrl("honorBackCtrl")
local exaltedPrivilegeCtrl = SoraDGetCtrl("exaltedPrivilegeCtrl")
local exclusiveVipRead = include("exclusiveVipRead")
_ENV, _ENV = nil, "exclusiveVipRead"
_ENV, ("exclusiveVipRead")[1], (nil).des = nil, nil, "privilege_text_35"
_ENV, ("exclusiveVipRead")[2], (nil).des = nil, nil, "privilege_text_38"
_ENV, ("exclusiveVipRead")[3], (nil).des = nil, nil, "privilege_text_39"
_ENV, ("exclusiveVipRead")[4], (nil).des = nil, nil, "privilege_text_40"
_ENV, ("exclusiveVipRead")[5], (nil).des = nil, nil, "privilege_text_133"
_ENV, ("exclusiveVipRead")[6], (nil).des = nil, nil, "privilege_text_134"
_ENV, ("exclusiveVipRead")[7], (nil).des = nil, nil, "privilege_text_135"
_ENV, ("exclusiveVipRead")[8], (nil).des = nil, nil, "privilege_text_136"
_ENV, ("exclusiveVipRead")[9], (nil).des = nil, nil, "privilege_text_137"
_ENV, ("exclusiveVipRead")[10], (nil).des = nil, nil, "privilege_text_148"
_ENV, ("exclusiveVipRead")[11], (nil).des = nil, nil, "privilege_text_174"
;("exclusiveVipRead")[12], (nil).des = nil, "privilege_text_148"
local privilegeItemList = "exclusiveVipRead"
local MAX_AWARD_NUM = 12
function exclusiveBirthdayNode:onInit()
	self.awards, _ENV = nil, nil
	self.ScrollViewItems = self.fields.ScrollViewItems
	self.imgTime = self.fields.imgTime
	self.Button_open = self.fields.Button_open
	self.txtNoWelfare = self.fields.txtNoWelfare
	self.Text_open_up = self.fields.Text_open_up
	self.Text_name = self.fields.Text_name
	self.Text_content = self.fields.Text_content
	self.Text_signature = self.fields.Text_signature
	self.txtTime = self.fields.txtTime
	self.Button_Detail = self.fields.Button_Detail
	self.Node_button = self.fields.Node_button
	self.txtTime = SoraDCreateTimerLabel(self, self.txtTime)
	self.Text_signature = SoraDCreateTimerLabel(self, self.Text_signature)
	self.txtNoWelfare:setString(i18n("common_text_4730"))
	self.Button_Detail:addClickEventListener(handler(self, self.btnDetailClick))
	self.Button_open:addClickEventListener(handler(self, self.btnOpenClick))
end
function exclusiveBirthdayNode:onShow()
	SoraDAddMessage(self, "MESSAGE_EXCLUSIVE_VIP_WELFARE_REFRESH", function(target, data)
		SoraDCloseLoading(self)
	end)
	if not SoraDFIsRA() then
		self.Button_Detail:setPositionX(self.txtNoWelfare:getPositionX() + self.txtNoWelfare:getContentSize().width + 10)
	end
end
function exclusiveBirthdayNode:initData(welfareInfo)
	self.welfareInfo = welfareInfo
	dump(self.welfareInfo, "self.welfareInfo========", 10)
	if not self.isOpen then
		if self.welfareInfo then
			local lastTime = self.welfareInfo.endTime - serviceFunctions.systemTime()
			self.controllers.c1:setSelectedIndex(0)
			self.imgTime:setVisible(true)
			self.txtTime:beginTime(lastTime)
			self.Text_open_up:setVisible(true)
			self.Button_open:setTouchEnabled(true)
			self.Text_signature:beginTime(lastTime)
			local isGot = exaltedPrivilegeCtrl:isAlreadyGotWelfare(self.welfareInfo.privilegeType, self.welfareInfo.opencount)
			self.Button_open:setTouchEnabled(not isGot)
			self.Text_open_up:setString(not isGot and i18n("common_text_1146") or i18n("common_text_1892"))
			if self.welfareInfo.privilegeType == gExaltedPrivilegeWelfareReward.MAGIC_CARPET or self.welfareInfo.privilegeType == gExaltedPrivilegeWelfareReward.FLYING_CASTLE then
				self.imgTime:setVisible(false)
			end
		else
			self.controllers.c1:setSelectedIndex(1)
			self.Button_open:setTouchEnabled(false)
		end
	else
		self.Text_name:setString(lordInfoCtrl:getBaseInfo().nickName .. ":")
		if SoraDFIsRA() then
			self.Text_name:setString(":" .. lordInfoCtrl:getBaseInfo().nickName)
		end
		self:showRewards()
		local str = privilegeItemList[self.welfareInfo.privilegeType].des or ""
		self.Text_content:setString(i18n(str))
		self.Text_content:setColor(cc.c3b(141, 110, 66))
		local isGot = exaltedPrivilegeCtrl:isAlreadyGotWelfare(self.welfareInfo.privilegeType, self.welfareInfo.opencount)
		self.Button_open:setTouchEnabled(not isGot)
		self.Text_open_up:setString(not isGot and i18n("common_text_1146") or i18n("common_text_1892"))
		if self.welfareInfo.privilegeType == gExaltedPrivilegeWelfareReward.MAGIC_CARPET or self.welfareInfo.privilegeType == gExaltedPrivilegeWelfareReward.FLYING_CASTLE then
			self.Text_signature:setVisible(false)
		else
			self.Text_signature:setVisible(true)
		end
		if not self.opend then
			local effect = SoraDCreatAnimation("xinfeng", nil, false)
			SoraDMixtureGLONEByParent(effect)
			self.Node_button:setContent(effect)
			effect:setPosition(3, -68)
			self.Particle_1 = SoraDGetChildByName(effect, "Particle_1")
			self.Particle_1:setVisible(false)
			exaltedPrivilegeCtrl = -68
			;(-68)[1] = cca.delay(0.13333333333333333)
			;(-68)[2] = cca.callFunc(function()
				self.Particle_1:resetSystem()
				self.Particle_1:setVisible(true)
			end)
			;(-68)[3] = cca.callFunc(function()
				self.Particle_1:resetSystem()
				self.Particle_1:setVisible(true)
			end)
			;(-68)[4] = cca.callFunc(function()
				self.Particle_1:resetSystem()
				self.Particle_1:setVisible(true)
			end)
			;(-68)[5] = cca.callFunc(function()
				self.Particle_1:resetSystem()
				self.Particle_1:setVisible(true)
			end)
			;(-68)[6] = cca.callFunc(function()
				self.Particle_1:resetSystem()
				self.Particle_1:setVisible(true)
			end)
			;(-68)[7] = cca.callFunc(function()
				self.Particle_1:resetSystem()
				self.Particle_1:setVisible(true)
			end)
			;(-68)[8] = cca.callFunc(function()
				self.Particle_1:resetSystem()
				self.Particle_1:setVisible(true)
			end)
			;(-68)[9] = cca.callFunc(function()
				self.Particle_1:resetSystem()
				self.Particle_1:setVisible(true)
			end)
			self.Particle_1:runAction(cca.seq(-68))
			_UPVALUE7_ = cca.seq(-68)
			cca.seq(-68)[1] = ffa.delay(0.13333333333333333)
			cca.seq(-68)[2] = ffa.scaleTo(0.06666666666666667, 0.9)
			cca.seq(-68)[3] = ffa.scaleTo(0.03333333333333333, 0.3)
			cca.seq(-68)[4] = ffa.scaleTo(0.08333333333333333, 0.73)
			cca.seq(-68)[5] = ffa.callFunc(function()
				self.controllers.c1:setSelectedIndex(2)
				self.fields.Node_opacity:setVisible(false)
			end)
			cca.seq(-68)[6] = ffa.scaleTo(0.08333333333333333, 1.05)
			cca.seq(-68)[7] = ffa.scaleTo(0.03333333333333333, 1.0)
			cca.seq(-68)[8] = ffa.callFunc(function()
				self.fields.Node_opacity:setVisible(true)
			end)
			cca.seq(-68)[9] = ffa.callFunc(function()
				self.fields.Node_opacity:setVisible(true)
			end)
			self:runAction(ffa.seq(cca.seq(-68)))
		else
			self.controllers.c1:setSelectedIndex(2)
		end
		self.opend = true
	end
end
function exclusiveBirthdayNode:showRewards()
	if self.welfareInfo.privilegeType == gExaltedPrivilegeWelfareReward.ACTIVITY then
		for k, v in pairs(exaltedPrivilegeCtrl:getWelfareInfo()) do
			if v.privilegeType == self.welfareInfo.privilegeType then
				self.rewardList = v.rewardData
				break
			end
		end
	else
		exclusiveVipRead = exclusiveVipRead
		exclusiveVipRead[1] = "id"
		exclusiveVipRead[2] = "count"
		self.rewardList = serviceFunctions.tableFormat(exclusiveVipRead:getPrivilegeReward(self.welfareInfo.privilegeType), exclusiveVipRead)
	end
	dump(self.rewardList, "self.rewardList")
	if self.rewardList and next(self.rewardList) then
		self.fields.ScrollViewItems:setItemRenderer(function(index, obj)
			local data = self.rewardList[index + 1]
			obj:initData(data.id, data.count)
		end)
		self.fields.ScrollViewItems:setNumItems(#self.rewardList)
	else
		self.fields.ScrollViewItems:setNumItems(0)
	end
end
function exclusiveBirthdayNode:btnOpenClick(button, touchType)
	SoraDPlaySound()
	if not self.isOpen then
		self.isOpen = true
		self:initData(self.welfareInfo)
		self.imgTime:setVisible(false)
	elseif self.welfareInfo then
		exaltedPrivilegeCtrl:reqGetReward(self.welfareInfo.privilegeType, self.welfareInfo.opencount)
		SoraDShowLoading(self)
		self.opend = false
		self.isOpen = false
	end
end
function exclusiveBirthdayNode:closeCallBack()
	if self.isOpen then
		_ENV = nil
		;(nil).msg = "MESSAGE_EXCLUSIVE_VIP_NEW_WINDOWS"
		SoraDSendMessage(nil)
	end
end
function exclusiveBirthdayNode:btnDetailClick(button, touchType)
	SoraDPlaySound()
	_ENV = nil
	;(nil).title = i18n("common_text_4731")
	;(nil).content = i18n("common_text_4732")
	uiManager:show("RuleView", nil)
end
return exclusiveBirthdayNode

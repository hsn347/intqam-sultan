local MAX_AWARD_NUM = 5
local gametop = gModuleMgr.getObject("gametop")
local cumuActiveCtrl = gametop.playertop_:getModule("cumuActiveCtrl")
local eventRechargeGoldForRewardSingle = class("eventRechargeGoldForRewardSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventRechargeGoldForRewardSingle")
	end
	return target
end)
function eventRechargeGoldForRewardSingle:ctor()
	self.awardArray, _ENV = nil, nil
	self.Text_more = SoraDGetChildByName(self, "Text_more")
	self.Text_more:setString("...")
	self.Button_more = SoraDGetChildByName(self, "Button_more")
	self.Button_more:setSwallowTouches(false)
	self.Button_more:setVisible(false)
	self.Button_more:addTouchEventListener(handler(self, self.showRewardDetail))
	self.Node_item = SoraDGetChildByName(self, "Node_item")
	self.Image_shadow = SoraDGetChildByName(self, "Image_shadow")
	self.Text_des = SoraDChangeTextToHtml(SoraDGetChildByName(self, "Text_des"))
	self.Text_limit = SoraDChangeTextToHtml(SoraDGetChildByName(self, "Text_limit"))
end
function eventRechargeGoldForRewardSingle:initData(data, otherData)
	self.data = data
	self.scroll = otherData.scroll
	self.view = otherData.view
	if type(self.data.range) == "number" then
		_ENV = nil
		_ENV, _ENV, (nil).num = self.data.range, string.formatnumberthousands(self.data.range), string.formatnumberthousands(self.data.range)
		self.data.range.color = "#ffff00"
		_ENV, string.formatnumberthousands(self.data.range).num, self.data.range.i = self.data.range, self.data.range, "true"
		string.formatnumberthousands(self.data.range).__default, self.data.range.color = self.data.range, "#aa9682"
		self.Text_des:setString(i18n_html("recharge_text_06", nil, (string.formatnumberthousands(self.data.range))))
	elseif type(self.data.range) == "table" then
		_ENV = i18n_html("recharge_text_06", nil, (string.formatnumberthousands(self.data.range)))
		i18n_html("recharge_text_06", nil, (string.formatnumberthousands(self.data.range))).num1 = string.formatnumberthousands(self.data.range.from)
		_ENV, _ENV, i18n_html("recharge_text_06", nil, (string.formatnumberthousands(self.data.range))).num2 = self.data.range.to, string.formatnumberthousands(self.data.range.to), string.formatnumberthousands(self.data.range.to)
		self.data.range.to.color = "#ffff00"
		_ENV, string.formatnumberthousands(self.data.range.to).num1, self.data.range.to.i = self.data.range.to, self.data.range.to, "true"
		self.data.range.to.color = "#ffff00"
		_ENV, string.formatnumberthousands(self.data.range.to).num2, self.data.range.to.i = self.data.range.to, self.data.range.to, "true"
		string.formatnumberthousands(self.data.range.to).__default, self.data.range.to.color = self.data.range.to, "#aa9682"
		self.Text_des:setString(i18n_html("recharge_text_05", i18n_html("recharge_text_06", nil, (string.formatnumberthousands(self.data.range)))))
	end
	local times = cumuActiveCtrl:getRechargeGoldData(self.data.minlv, self.data.gold)
	if self.data.limit > 0 then
		local leftCount = self.data.limit - times
		_ENV = i18n_html("recharge_text_05", i18n_html("recharge_text_06", nil, (string.formatnumberthousands(self.data.range))))
		i18n_html("recharge_text_05", i18n_html("recharge_text_06", nil, (string.formatnumberthousands(self.data.range)))).num = leftCount
		_ENV, i18n_html("recharge_text_05", i18n_html("recharge_text_06", nil, (string.formatnumberthousands(self.data.range)))).total = self.data.limit, self.data.limit
		if 0 < leftCount then
			_ENV = i18n_html("recharge_text_05", i18n_html("recharge_text_06", nil, (string.formatnumberthousands(self.data.range))))
			i18n_html("recharge_text_05", i18n_html("recharge_text_06", nil, (string.formatnumberthousands(self.data.range)))).color = "#ffff00"
			if i18n_html("recharge_text_05", i18n_html("recharge_text_06", nil, (string.formatnumberthousands(self.data.range)))) then
				goto lbl_105
			end
		end
		_ENV = i18n_html("recharge_text_05", i18n_html("recharge_text_06", nil, (string.formatnumberthousands(self.data.range))))
		_ENV, self.data.limit.num, i18n_html("recharge_text_05", i18n_html("recharge_text_06", nil, (string.formatnumberthousands(self.data.range)))).color = i18n_html("recharge_text_05", i18n_html("recharge_text_06", nil, (string.formatnumberthousands(self.data.range))))
		::lbl_105::
		self.data.limit.__default, i18n_html("recharge_text_05", i18n_html("recharge_text_06", nil, (string.formatnumberthousands(self.data.range)))).color = i18n_html("recharge_text_05", i18n_html("recharge_text_06", nil, (string.formatnumberthousands(self.data.range))))
		self.Text_limit:setString(i18n_html("god_beast_text_13", i18n_html("recharge_text_05", i18n_html("recharge_text_06", nil, (string.formatnumberthousands(self.data.range))))))
		self.Image_shadow:setVisible(leftCount <= 0)
	else
		self.Text_limit:setString(string.format("%s%d", i18n("reurn_text_08"), times))
		self.Text_limit:setColor(cc.c3b(110, 85, 65))
		self.Image_shadow:setVisible(false)
	end
	self:setAward()
end
function eventRechargeGoldForRewardSingle:setAward()
	self.Button_more:setVisible(#self.data.reward > MAX_AWARD_NUM)
	for k, v in ipairs(self.data.reward) do
		if not self.awardArray[k] and k <= MAX_AWARD_NUM then
			self.awardArray[k] = include("commonItemAward").new()
			self.awardArray[k]:setScale(0.8)
			self.awardArray[k]:setBaseScale(1.0)
			self.awardArray[k]:setOwnView(self.view)
			self.awardArray[k]:setOwnScroll(self.ownScroll)
			self.awardArray[k]:setPosition(SoraDFPosX(640 - (80 + (k - 1) * 100)), 60)
			self.awardArray[k]:addTo(self.Node_item)
		end
		if self.awardArray[k] then
			self.awardArray[k]:initData(v.id, v.count)
			self.awardArray[k]:setVisible(k <= MAX_AWARD_NUM)
		end
	end
	if #self.awardArray > #self.data.reward then
		for k = #self.awardArray, #self.data.reward + 1, -1 do
			self.awardArray[k]:setVisible(false)
		end
	end
end
function eventRechargeGoldForRewardSingle:showRewardDetail(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("commonMoreGiftView")
		panel:initData(self.data.reward, i18n("privilege_text_124"), self.Text_des:getString())
		panel:show()
	end
end
return eventRechargeGoldForRewardSingle

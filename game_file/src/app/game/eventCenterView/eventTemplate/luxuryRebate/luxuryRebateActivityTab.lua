local gametop = gModuleMgr.getObject("gametop")
local luxuryRebateCtrl = gametop.playertop_:getModule("luxuryRebateCtrl")
local commonTabBtnEX = include("commonTabBtnEX")
local luxuryRebateActivityTab = class("luxuryRebateActivityTab", function(target)
	if target ~= nil then
		target = commonTabBtnEX.new(target)
	end
	return target
end)
function luxuryRebateActivityTab:ctor()
end
function luxuryRebateActivityTab:initView(param)
	commonTabBtnEX.initView(self, param)
	for i = 1, self.tabNum do
		local Text_name = SoraDGetChildByName(self.tabArray[i], "Text_name")
		SoraDCreateTimerLabel(self, Text_name)
		_G.SoraDChangeTextToHtml(Text_name)
	end
end
function luxuryRebateActivityTab:setAwardEffect(node, show)
	if show then
		if not node.effectNode then
			local effect = SoraDCreatAnimation("luxuryRebateEffect_tab", nil, true)
			effect:setPosition(64, 32)
			effect:addTo(node, 1)
			node.effectNode = effect
		end
		node.effectNode:setVisible(true)
	elseif node.effectNode then
		node.effectNode:setVisible(false)
	end
end
function luxuryRebateActivityTab:updateStatus()
	local day = luxuryRebateCtrl:getRechargeCurDay()
	for i = 1, self.tabNum do
		local Text_name = SoraDGetChildByName(self.tabArray[i], "Text_name")
		Text_name:endTime()
		if i < day then
			local numColor = cc.c3b(218, 100, 62)
			luxuryRebateCtrl = [[

%{status}]]
			luxuryRebateCtrl, luxuryRebateCtrl, ([[

%{status}]]).status = "Anchor_text_21", i18n("Anchor_text_21"), i18n("Anchor_text_21")
			i18n("Anchor_text_21").status, ("Anchor_text_21").color = "Anchor_text_21", numColor
			local strDes = _G.i18n_html(self.paramArray[i].title .. [[

%{status}]], [[

%{status}]], (i18n("Anchor_text_21")))
			Text_name:setString(strDes)
		elseif day == i and luxuryRebateCtrl:isRechargeActive() then
			local str_format = self.paramArray[i].title .. [[

%{time}]]
			Text_name:setTimeLast(function(time)
				_ENV = nil
				;(nil).time = time
				local strDes = _G.i18n_html(str_format, nil)
				return strDes
			end)
			Text_name:beginTime(serviceFunctions.getTodayRemainTime())
		end
		self:setAwardEffect(self.tabArray[i], i == 3)
	end
end
return luxuryRebateActivityTab

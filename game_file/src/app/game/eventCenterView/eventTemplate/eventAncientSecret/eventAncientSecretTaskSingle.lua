local gametop = gModuleMgr.getObject("gametop")
local ancientTreasureCtrl = gametop.playertop_:getModule("ancientTreasureCtrl")
local MAX_AWARD_NUM = 5
local eventAncientSecretTaskSingle = class("eventAncientSecretTaskSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventAncientSecretTaskSingle")
	end
	return target
end)
function eventAncientSecretTaskSingle:ctor()
	self.awardArray, _ENV, self.data, _ENV = nil, nil, nil, nil
	self.Button_go = SoraDGetChildByName(self, "Button_go")
	SoraDAutoSizeButtonText(self.Button_go, cc.size(120, 50))
	self.Button_go:setSwallowTouches(false)
	self.Button_go:setTitleText(i18n("common_text_477"))
	self.Button_go:addTouchEventListener(handler(self, self.onBtnGoClick))
	self.Text_des = SoraDChangeTextToHtml(SoraDGetChildByName(self, "Text_des"))
	self.Text_schedule = SoraDChangeTextToHtml(SoraDGetChildByName(self, "Text_schedule"))
end
function eventAncientSecretTaskSingle:initData(data, otherData)
	self.data = data
	self.view = otherData.view
	self.ownScroll = otherData.scroll
	local lang = self.data.describe
	local total = self.data.condition or 0
	_ENV = nil
	_ENV, _ENV, (nil).num = total, string.formatnumberthousands(total), string.formatnumberthousands(total)
	total.color = "#ffff00"
	_ENV, string.formatnumberthousands(total).num, total.i = total, total, "true"
	string.formatnumberthousands(total).__default, total.color = total, "#c8aa96"
	self.Text_des:setString(i18n_html(lang, nil, (string.formatnumberthousands(total))))
	local amount = ancientTreasureCtrl:getCountByEvent(self.data.event) or 0
	_ENV = i18n_html(lang, nil, (string.formatnumberthousands(total)))
	i18n_html(lang, nil, (string.formatnumberthousands(total))).count = string.formatnumberthousands(amount)
	_ENV, i18n_html(lang, nil, (string.formatnumberthousands(total))).total = string.formatnumberthousands(total), string.formatnumberthousands(total)
	if total <= amount then
		_ENV = total
		total.color = "#d7c39b"
		if total then
			goto lbl_65
		end
	end
	_ENV = total
	_ENV, string.formatnumberthousands(total).count, total.color = total, total, "#be2828"
	::lbl_65::
	_ENV, string.formatnumberthousands(total).total, total.color = total, total, "#d7c39b"
	string.formatnumberthousands(total).__default, total.color = total, "#d7c39b"
	self.Text_schedule:setString(i18n_html("common_text_3683", i18n_html(lang, nil, (string.formatnumberthousands(total)))))
	self:setAward()
	self.status = ancientTreasureCtrl:getTaskStatus(self.data.index, amount, total)
	self:setBtnStatus(self.status)
	if self.data.event == 5 then
		self.Button_go:setVisible(self.status ~= gBtnTargetStatusDef.GO)
	else
		self.Button_go:setVisible(true)
	end
end
function eventAncientSecretTaskSingle:setBtnStatus(status)
	self.Button_go:setBright(status ~= gBtnTargetStatusDef.GOT)
	self.Button_go:setTitleText(status == gBtnTargetStatusDef.GO and i18n("common_text_477") or status == gBtnTargetStatusDef.GET and i18n("common_text_1146") or status == gBtnTargetStatusDef.GOT and i18n("common_text_1892"))
	self.Button_go:setTitleColor(status == gBtnTargetStatusDef.GOT and cc.c3b(120, 120, 120) or cc.c3b(255, 255, 255))
	self.Button_go:loadTextureNormal(status == gBtnTargetStatusDef.GO and "btn_yellow_small_01.png" or status == gBtnTargetStatusDef.GET and "btn_green_small_01.png" or "btn_gray_small.png", ccui.TextureResType.plistType)
end
function eventAncientSecretTaskSingle:setAward()
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local reward = serviceFunctions.tableFormat(self.data.reward, nil)
	for k, v in ipairs(reward) do
		if not self.awardArray[k] and k <= MAX_AWARD_NUM then
			self.awardArray[k] = include("commonItemAward").new()
			self.awardArray[k]:setScale(0.8)
			self.awardArray[k]:setBaseScale(1.0)
			self.awardArray[k]:setOwnView(self.view)
			self.awardArray[k]:setOwnScroll(self.ownScroll)
			self.awardArray[k]:setPosition(SoraDFPosX(640 - (80 + (k - 1) * 90)), 60)
			self.awardArray[k]:addTo(self, 9)
		end
		if self.awardArray[k] then
			self.awardArray[k]:initData(v.id, v.count)
			self.awardArray[k]:setVisible(k <= MAX_AWARD_NUM)
		end
	end
	if #self.awardArray > #reward then
		for k = #self.awardArray, #reward + 1, -1 do
			self.awardArray[k]:setVisible(false)
		end
	end
end
function eventAncientSecretTaskSingle:onBtnGoClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.status == gBtnTargetStatusDef.GET then
			SoraDShowLoading(self.view)
			ancientTreasureCtrl:sendGetRewardMsg(self.data.index)
		elseif self.status == gBtnTargetStatusDef.GO then
			if string.len(self.data.guideId) > 0 then
				local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
				local ret = mildGuideManager:starMildByNewPlayerStringParam(self.data.guideId)
				if ret ~= false then
					SoraDRemoveAllPanelFromManager()
				end
			else
				self.ownScroll:jumpToTop()
			end
		end
	end
end
return eventAncientSecretTaskSingle

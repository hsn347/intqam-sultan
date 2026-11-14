local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local MAX_AWARD_NUM = 5
local equipActivityTaskSingle = class("equipActivityTaskSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("equipActivityTaskSingle")
	end
	return target
end)
function equipActivityTaskSingle:ctor()
	self.awardArray, _ENV = nil, nil
	self.Sprite_bg = SoraDGetChildByName(self, "Sprite_bg")
	self.Text_taskName = SoraDChangeTextToHtml(SoraDGetChildByName(self, "Text_taskName"))
	self.Text_Claimed = SoraDGetChildByName(self, "Text_Claimed")
	self.Text_Claimed:setString(i18n("common_text_1892"))
	self.Node_items = SoraDGetChildByName(self, "Node_items")
	self.Text_schedule = SoraDChangeTextToHtml(SoraDGetChildByName(self, "Text_schedule"))
	self.Button_go = SoraDGetChildByName(self, "Button_go")
	self.Button_go:setTitleText(i18n("common_text_477"))
	self.Button_go:setSwallowTouches(false)
	self.Button_go = include("commonBtnInstance").new(self.Button_go)
	self.Button_go:setHandle(handler(self, self.onGoClick))
	self.Button_claim = SoraDGetChildByName(self, "Button_claim")
	self.Button_claim:setTitleText(i18n("common_text_677"))
	self.Button_claim:setSwallowTouches(false)
	self.Button_claim = include("commonBtnInstance").new(self.Button_claim)
	self.Button_claim:setHandle(handler(self, self.onClaimClick))
end
function equipActivityTaskSingle:initData(data, otherData)
	self.data = data
	self.ownScroll = otherData.scroll
	self.view = otherData.view
	_ENV = nil
	;(nil).count = string.formatnumberthousands(self.data.cur)
	_ENV, (nil).total = string.formatnumberthousands(self.data.aim), string.formatnumberthousands(self.data.aim)
	if self.data.cur >= self.data.aim then
		_ENV = self.data.cur
		self.data.cur.color = "#ffffff"
		if self.data.cur then
			goto lbl_36
		end
	end
	_ENV = self.data.cur
	_ENV, string.formatnumberthousands(self.data.aim).count, self.data.cur.color = self.data.cur, self.data.cur, "#d70000"
	::lbl_36::
	_ENV, string.formatnumberthousands(self.data.aim).total, self.data.cur.color = self.data.cur, self.data.cur, "#ffffff"
	string.formatnumberthousands(self.data.aim).__default, self.data.cur.color = self.data.cur, "#ffffff"
	self.Text_schedule:setString(i18n_html("common_text_3683", nil, (string.formatnumberthousands(self.data.aim))))
	self.Button_go:setScroll(self.ownScroll)
	self.Button_claim:setScroll(self.ownScroll)
	local showNum = type(self.data.name.num) == "number" and string.formatnumberthousands(self.data.name.num) or self.data.name.num
	_ENV = i18n_html("common_text_3683", nil, (string.formatnumberthousands(self.data.aim)))
	_ENV, _ENV, i18n_html("common_text_3683", nil, (string.formatnumberthousands(self.data.aim))).num = i18n_html("common_text_3683", nil, (string.formatnumberthousands(self.data.aim)))
	i18n_html("common_text_3683", nil, (string.formatnumberthousands(self.data.aim))).color = "#FFD43E"
	_ENV, i18n_html("common_text_3683", nil, (string.formatnumberthousands(self.data.aim))).num, i18n_html("common_text_3683", nil, (string.formatnumberthousands(self.data.aim))).i = i18n_html("common_text_3683", nil, (string.formatnumberthousands(self.data.aim)))
	i18n_html("common_text_3683", nil, (string.formatnumberthousands(self.data.aim))).__default, i18n_html("common_text_3683", nil, (string.formatnumberthousands(self.data.aim))).color = i18n_html("common_text_3683", nil, (string.formatnumberthousands(self.data.aim)))
	self.Text_taskName:setString(i18n_html(self.data.name[1], i18n_html("common_text_3683", nil, (string.formatnumberthousands(self.data.aim)))))
	self.Text_Claimed:setVisible(self.data.status == gBtnTargetStatusDef.GOT)
	self.Text_schedule:setVisible(self.data.status ~= gBtnTargetStatusDef.GOT)
	self.Button_go:setVisible(self.data.status ~= gBtnTargetStatusDef.GOT and self.data.cur < self.data.aim)
	self.Button_claim:setVisible(self.data.status ~= gBtnTargetStatusDef.GOT and self.data.cur >= self.data.aim)
	self.Sprite_bg:loadTexture(self.data.status == gBtnTargetStatusDef.GO and "frame_bqp_cell_02.png" or "frame_bqp_cell_03.png", ccui.TextureResType.plistType)
	self:setReward()
end
function equipActivityTaskSingle:setReward()
	for k, v in ipairs(self.data.reward) do
		if not self.awardArray[k] and k <= MAX_AWARD_NUM then
			self.awardArray[k] = include("commonItemAward").new()
			self.awardArray[k]:setScale(0.5)
			self.awardArray[k]:setBaseScale(1.0)
			self.awardArray[k]:setOwnView(self.view)
			self.awardArray[k]:setOwnScroll(self.ownScroll)
			self.awardArray[k]:setPosition(SoraDFPosX(60 - 60 * k, 0), 0)
			self.awardArray[k]:addTo(self.Node_items)
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
function equipActivityTaskSingle:onGoClick(target, event)
	if self.data.guideId and string.len(self.data.guideId) > 0 then
		local ret, isNotClose = gModuleMgr.sharedMgr("mildGuideManager"):starMildByNewPlayerStringParam(self.data.guideId)
		if ret ~= false and not isNotClose then
			SoraDRemoveAllPanelFromManager()
		end
	end
end
function equipActivityTaskSingle:onClaimClick(target, event)
	SoraDShowLoading(self.view)
	activityTaskComponentCtrl:reqRuestClaimReward(self.data.questID, gActivityTimeActivityID.EQUIP_ACTIVITY)
end
return equipActivityTaskSingle

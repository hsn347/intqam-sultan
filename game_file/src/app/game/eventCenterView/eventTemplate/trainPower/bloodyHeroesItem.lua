local gametop = gModuleMgr.getObject("gametop")
local eventRecruitmentMaterialsSingle = include("eventRecruitmentMaterialsSingle")
local groomHorsesCtrl = gametop.playertop_:getModule("groomHorsesCtrl")
local activityTaskComponentCtrl = gametop.playertop_:getModule("activityTaskComponentCtrl")
local bloodyHeroesItem = class("bloodyHeroesItem", eventRecruitmentMaterialsSingle)
local MAX_AWARD_NUM = 5
function bloodyHeroesItem:ctor()
	bloodyHeroesItem.super.ctor(self)
	self.frame_rxyy_btk_1 = SoraDGetChildByName(self, "frame_rxyy_btk_1")
	self.frame_sdgl_wzgl_dk_1 = SoraDGetChildByName(self, "frame_sdgl_wzgl_dk_1")
	self.frame_rxyy_btk_1:setVisible(false)
end
function bloodyHeroesItem:initData(data, otherData)
	self.data = data
	self.view = otherData.view
	dump(data, "fsdfjkdjfkdjfkdf")
	dump(otherData, "fsdfjkdjfkdjfkdf54545")
	self:setBtnStatus()
	self:setAward()
end
function bloodyHeroesItem:setBtnStatus()
	self.finishNode:setVisible(false)
	self.Button_go:setVisible(true)
	self.Button_go:setTitleText(self.data.taskStatus == gBtnTargetStatusDef.GO and i18n("common_text_477") or self.data.taskStatus == gBtnTargetStatusDef.GET and i18n("common_text_1146") or self.data.taskStatus == gBtnTargetStatusDef.GOT and i18n("common_text_1892"))
	self.Button_go:setTitleColor(self.data.taskStatus == gBtnTargetStatusDef.GOT and cc.c3b(120, 120, 120) or cc.c3b(255, 255, 255))
	if self.data.taskStatus == gBtnTargetStatusDef.GOT then
		self.finishNode:setVisible(true)
		self.Button_go:setVisible(false)
		self.Button_go:loadTextures("btn_gray_small.png", "btn_gray_small.png", "btn_gray_small.png", ccui.TextureResType.plistType)
	elseif self.data.taskStatus == gBtnTargetStatusDef.GO then
		self.Button_go:loadTextures("btn_yellow_small_01.png", "btn_yellow_small_01.png", "btn_yellow_small_01.png", ccui.TextureResType.plistType)
	else
		self.Button_go:loadTextures("btn_green_small_01.png", "btn_green_small_01.png", "btn_green_small_01.png", ccui.TextureResType.plistType)
	end
	local color = "#be2828"
	if self.data.count >= self.data.total then
		self.data.count = self.data.total
		color = "#FFEBB9"
	end
	_ENV = ccui.TextureResType.plistType
	ccui.TextureResType.plistType.count = string.formatnumberthousands(self.data.count)
	_ENV, _ENV, ccui.TextureResType.plistType.total = self.data.total, string.formatnumberthousands(self.data.total), string.formatnumberthousands(self.data.total)
	_ENV, string.formatnumberthousands(self.data.total).count, self.data.total.color = self.data.total, self.data.total, color
	string.formatnumberthousands(self.data.total).__default, self.data.total.color = self.data.total, "#D7C39B"
	self.Text_schedule:setString(_G.i18n_html("common_text_3683", ccui.TextureResType.plistType, (string.formatnumberthousands(self.data.total))))
	_ENV = _G.i18n_html("common_text_3683", ccui.TextureResType.plistType, (string.formatnumberthousands(self.data.total)))
	_ENV, _ENV, _G.i18n_html("common_text_3683", ccui.TextureResType.plistType, (string.formatnumberthousands(self.data.total))).num = _G.i18n_html("common_text_3683", ccui.TextureResType.plistType, (string.formatnumberthousands(self.data.total)))
	_ENV, self.data.taskDes.num.num, _G.i18n_html("common_text_3683", ccui.TextureResType.plistType, (string.formatnumberthousands(self.data.total))).color = _G.i18n_html("common_text_3683", ccui.TextureResType.plistType, (string.formatnumberthousands(self.data.total)))
	self.data.taskDes.num.__default, _G.i18n_html("common_text_3683", ccui.TextureResType.plistType, (string.formatnumberthousands(self.data.total))).color = _G.i18n_html("common_text_3683", ccui.TextureResType.plistType, (string.formatnumberthousands(self.data.total)))
	self.Text_des:setString(i18n_html(self.data.taskDes[1], _G.i18n_html("common_text_3683", ccui.TextureResType.plistType, (string.formatnumberthousands(self.data.total)))))
end
function bloodyHeroesItem:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.data.taskStatus == gBtnTargetStatusDef.GO then
			local guideId = self.data.guideId
			local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
			local tbParam = mildGuideManager:splitGuideParam(guideId)
			if guideId then
				local lang = self.data.taskDes[1]
				if not lang or lang == "" then
					lang = "NA"
				end
				_ENV = nil
				;(nil).power = self.data.taskDes.power or ""
				;(nil).lv = self.data.taskDes.lv or ""
				tbParam.msg = i18n(lang, nil)
				tbParam.minLv = self.data.taskDes.lv
				if tbParam.id == gNewPLayerTaskType.POP_TIP then
					SoraDShowMsgTip(i18n(self.data.taskDes))
				end
				local ret, notNeedClose = mildGuideManager:starMildByNewPlayerQuestID(tbParam.id, tbParam)
				if not notNeedClose then
					SoraDRemoveAllPanelFromManager()
				end
			end
		elseif self.data.taskStatus == gBtnTargetStatusDef.GET then
			SoraDShowLoading(self.view)
			activityTaskComponentCtrl:reqRuestClaimReward(self.data.taskID, gActivityTimeActivityID.IRON_BLOOD_ACTIVITY)
		end
	end
end
function bloodyHeroesItem:setAward()
	self.frame_sdgl_wzgl_dk_1:removeAllChildren()
	for i, v in ipairs(self.data.award) do
		local award = include("commonItemAward").new()
		award:setScale(0.8)
		award:setBaseScale(1.0)
		award:setOwnView(self.view)
		award:setOwnScroll(self.ownScroll)
		award:initData(v.id, v.count)
		if SoraDFIsRA() then
			award:setPosition(580 - (i - 1) * 90, 60)
		else
			award:setPosition(55 + (i - 1) * 90, 60)
		end
		award:addTo(self.frame_sdgl_wzgl_dk_1, 10)
	end
end
return bloodyHeroesItem

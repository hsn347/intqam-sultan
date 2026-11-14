local baseFguiPanel = require("fgui.base.baseFguiPanel")
local IceDragonCavePanel = class("IceDragonCavePanel", baseFguiPanel)
local iceDragonCaveCtrl = SoraDGetCtrl("iceDragonCaveCtrl")
local iceDragonCaveRead = include("iceDragonCaveRead")
local constantRead = include("constantRead")
local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
function IceDragonCavePanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	self.itemID = 859501
	self.isHideCurrentSceneView = true
	self.activityID = gActivityTimeActivityID.ICE_DRAGON_CAVE_ACTIVITY
	print("IceDragonCavePanel:ctor", self.viewName)
end
function IceDragonCavePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function IceDragonCavePanel:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
	print("=======IceDragonCavePanel:onInit")
	self.fields.Com_title:initData(i18n("activity_name_9001478"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.fields.btn_reward:setTitle(i18n("decrypt_text_03"))
	self.fields.btn_reward:addClickEventListener(handler(self, self.onRewardPreviewClick), 1)
	self.fields.btn_one:addClickEventListener(handler(self, self.onOneClick), 1)
	self.fields.btn_ten:addClickEventListener(handler(self, self.onTenClick), 10)
	_ENV = self.onTenClick
	self.onTenClick.num = 1
	self.fields.btn_one:setTitle(i18n("Canyon_Treasur_text_15", self.onTenClick))
	_ENV = "+%s"
	;("+%s").color = cc.c3b(42, 255, 0)
	local str = SoraDWrapHtmlTagByStyle(string.format("+%s", "" .. 1), "+%s")
	_ENV = 255
	_ENV, (255).num = string.format("10%s", str), string.format("10%s", str)
	self.fields.btn_ten:setTitle(i18n_html("Canyon_Treasur_text_15", 255, (string.format("10%s", str))))
	self.fields.free_tips:setString(i18n("dragoncave_text_03"))
	self.boxInfo = iceDragonCaveRead:getRewardCfgList()
	local showCfg = iceDragonCaveRead.getShowCfg()
	self.rewardItem1 = showCfg.showItem[1]
	self.rewardItem2 = showCfg.showItem[2]
	self.fields.item1:initData(self.rewardItem1)
	self.fields.item2:initData(self.rewardItem2)
	self.fields.Com_have:initData(self.itemID)
	iceDragonCaveCtrl:sendInitMsg()
end
function IceDragonCavePanel:onShow()
	print("=======IceDragonCavePanel:onShow")
	self.fields.Usm_1:setSpeed(2, 1)
	self:updateView()
end
function IceDragonCavePanel:updateProgress()
	local personScore = iceDragonCaveCtrl:getDrawCount()
	local passIndex = 0
	local scorllIdx = 0
	local fields = fguiHelper.get_fields(self.fields.progress)
	fields.List_box:setItemRenderer(handler(self, self.onBoxRenderer))
	fields.progress:fix()
	fields.List_box:setNumItems(#self.boxInfo)
	local singlePassPercent = 1 / (#self.boxInfo - 1) * 100
	for i, v in ipairs(self.boxInfo) do
		if personScore >= v.draw then
			passIndex = passIndex + 1
			if iceDragonCaveCtrl:getIsReceived(v.draw) == gBtnTargetStatusDef.GOT then
				scorllIdx = scorllIdx + 1
			end
		end
	end
	if personScore < self.boxInfo[1].draw or passIndex == 0 then
		fields.progress:setPercent(0)
	elseif passIndex < #self.boxInfo then
		local littlePercent = (personScore - self.boxInfo[passIndex].draw) / (self.boxInfo[passIndex + 1].draw - self.boxInfo[passIndex].draw) * singlePassPercent
		fields.progress:setPercent((singlePassPercent * (passIndex - 1) + littlePercent) / 100)
	else
		fields.progress:setPercent(1)
	end
	iceDragonCaveCtrl = handler(self, self.onBoxRenderer)
	handler(self, self.onBoxRenderer).num = personScore
	self.fields.Text_curScore:setString(i18n("common_text_2557", handler(self, self.onBoxRenderer)))
	local tmpW = 796 / #self.boxInfo
	if SoraDFIsRA() then
		self.fields.progress:getScrollPane():setPosX(-(-196 + (tmpW * scorllIdx - 1)), true)
	else
		self.fields.progress:getScrollPane():setPosX(tmpW * scorllIdx, true)
	end
end
function IceDragonCavePanel:updateView()
	self:updateProgress()
	self.haveNum = self.fields.Com_have:updateNum()
	self.fields.btn_one:setCost(self.itemID, 1, true)
	self.fields.btn_ten:setCost(self.itemID, 10, true)
end
function IceDragonCavePanel:showReward(reward)
	self.fields.mask:setVisible(true)
	self.fields.mask:runAction(ffa.seq(ffa.delay(2), ffa.callFunc(function()
		self.fields.mask:setVisible(false)
	end)))
	SoraDPlaySound("ice_dragon_cave", "dragon_cava_lock")
	if #reward == 1 then
		self.fields.Usm_1:setEffectPath("bingldxfzps_01.usm,bingldxdj_01.usm,bingldxfzcx_01.usm,bingldxfzdj_01.usm", true, true)
		self.fields.Usm_1:getCriSprite():setSpeed(2, 1)
		self:stopAllActions()
		self:runAction(ffa.seq(ffa.delay(2), ffa.callFunc(function(data)
			SoraDMailGainItems(reward, true)
		end)))
	else
		self.fields.Usm_1:setMaxChunkSize(113248)
		self.fields.Usm_1:setEffectPath("bingldxfzps_01.usm,bingldxdj_01.usm", true, true)
		self.fields.Usm_1:getCriSprite():setSpeed(2, 1)
		_ENV = 2
		;(2).frame = 30
		self.fields.Usm_1:getCriSprite():addFrameEventData(2)
		self:stopAllActions()
		self:runAction(ffa.seq(ffa.delay(2), ffa.callFunc(function(data)
			_ENV = nil
			;(nil).reward = reward
			;(nil).callFunc = function()
				if self.fields then
					self.fields.Usm_1:setEffectPath("bingldxfzcx_01.usm,bingldxfzdj_01.usm", true)
					self.fields.Usm_1:getCriSprite():setSpeed(2, 1)
				end
			end
			uiManager:show("IceDragonCaveDrawReward", nil)
		end)))
	end
end
function IceDragonCavePanel:onOneClick(sender, params)
	SoraDPlaySound()
	if not self:checkItem(1) then
		return
	end
	iceDragonCaveCtrl:reqCaveDrawOne()
end
function IceDragonCavePanel:onTenClick(sender, params)
	SoraDPlaySound()
	if not self:checkItem(10) then
		return
	end
	iceDragonCaveCtrl:reqCaveDrawTen()
end
function IceDragonCavePanel:getGiftInfo()
	local idTbl = include("activityTimeRead").getRechargeId(self.activityID)
	local giftInfo = rechargeActivityCtrl:getHotActivityList()
	for i = 3, 1, -1 do
		local item = giftInfo[tostring(idTbl[i])]
		if item and 1 <= tonumber(item.extraData) then
			return item
		end
	end
end
function IceDragonCavePanel:checkItem(num)
	if num > self.haveNum then
		SoraDShowMsgBox(i18n("dragoncave_text_02"), i18n("common_text_204"), nil, function(type)
			if type == MSGBOX_CALLBACK_YES then
				local giftData = self:getGiftInfo()
				if giftData then
					if GLOBAL_GAME_RECHARGE_MODE then
						_ENV = nil
						;(nil).rechargeID = tonumber(giftData.ID)
						uiManager:show("rechargeView", nil)
					else
						local panel = SoraDCreatePanel("rechargeView")
						panel:jumpToLimitNode(giftData.category, tonumber(giftData.ID))
						panel:show()
					end
				else
					SoraDShowMsgTip(i18n("HeroVault_text_03"))
				end
			end
		end)
		return false
	end
	return true
end
function IceDragonCavePanel:onRewardPreviewClick()
	SoraDPlaySound()
	uiManager:show("IceDragonCaveReward")
end
function IceDragonCavePanel:onBoxRenderer(index, obj)
	local boxInfo = self.boxInfo[index + 1]
	obj:initData(boxInfo, index + 1)
	obj:setClickHandler(handler(self, self.buttonGetRewardCallBack))
end
function IceDragonCavePanel:buttonGetRewardCallBack(button, index)
	SoraDPlaySound()
	local data = self.boxInfo[index]
	local getStatus = iceDragonCaveCtrl:getIsReceived(data.draw)
	if getStatus == gBtnTargetStatusDef.GET then
		iceDragonCaveCtrl:reqCaveReceive(data.draw)
	else
		_ENV = nil
		;(nil).index = index
		;(nil).data = self.boxInfo[index]
		uiManager:show("IceDragonCaveBoxReward", nil)
	end
end
function IceDragonCavePanel:onAddClick()
	SoraDPlaySound()
	if GLOBAL_GAME_RECHARGE_MODE then
		uiManager:show("rechargeView")
	else
		SoraDCreatePanel("rechargeView"):show()
	end
end
function IceDragonCavePanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("dragoncave_text_01")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
return IceDragonCavePanel

local publicRead = include("publicRead")
local armyLogic = include("armyLogic")
local luckyBlessCtrl = SoraDGetCtrl("luckyBlessCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_res = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://soldiersCampView/Btn_res", Btn_res)
function Btn_res:onInit()
	self.resCost = 0
	self:addClickListener(handler(self, self.onClick))
end
function Btn_res:onShow()
end
function Btn_res:initData(data, needResList, parent)
	self.resID = data.resID or data.resid
	self.isArmor = data.isArmor
	self.isT13Army = data.isT13Army
	self.handle = data.handle
	self.needResList = needResList
	self.parent = parent
	self.fields.icon:setSpriteFrame(publicRead.getIcon(self.resID))
	local curBlessType = luckyBlessCtrl:getCurEffectType()
	if curBlessType and curBlessType == gLuckyBlessActivityEffectType.TRAIN_SOLDIERS and not data.noDiscount then
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Text_ori:setString(SoraDConvertNumberWithUnit(data.rescount))
		local luckyResCount = luckyBlessCtrl:getResult(data.rescount)
		self.fields.Text_cur:setString(SoraDConvertNumberWithUnit(luckyResCount))
		self.controllers.c2:setSelectedIndex(luckyResCount <= data.curcount and 0 or 1)
		self.resCost = serviceFunctions.resConvertToGold(self.resID, math.max(0, luckyResCount - data.curcount))
	else
		self.controllers.c1:setSelectedIndex(1)
		if data.showOwn then
			publicRead = math.max(0, luckyResCount - data.curcount)
			math.max(0, luckyResCount - data.curcount).member = SoraDConvertNumberWithUnit(data.rescount)
			math.max(0, luckyResCount - data.curcount).total = SoraDConvertNumberWithUnit(data.curcount)
			self.fields.Text_count:setString(i18n("common_text_155", math.max(0, luckyResCount - data.curcount)))
		else
			self.fields.Text_count:setString(SoraDConvertNumberWithUnit(data.rescount))
		end
		self.controllers.c2:setSelectedIndex(data.curcount >= data.rescount and 0 or 1)
		self.resCost = serviceFunctions.resConvertToGold(self.resID, math.max(0, data.rescount - data.curcount))
	end
end
function Btn_res:setResColor(color)
	if self.controllers.c2:getSelectedIndex() == 1 then
		return
	end
	if self.controllers.c1:getSelectedIndex() == 0 then
		self.fields.Text_cur:setColor(color)
	else
		self.fields.Text_count:setColor(color)
	end
end
function Btn_res:getResCost()
	return self.resCost
end
function Btn_res:onClick()
	SoraDPlaySound()
	if self.resID == gIDDef.ELITE_POINT then
		return
	end
	if self.isArmor then
		if self.handle then
			SoraDShowLoading(nil, nil, nil, true, 0.016666666666666666)
			_UPVALUE1_ = nil
			;(nil)[1] = ffa.delay(0.016666666666666666)
			;(nil)[2] = ffa.callFunc(function()
				SoraDCloseLoading()
				self.handle(self.resID)
			end)
			;(nil)[3] = ffa.callFunc(function()
				SoraDCloseLoading()
				self.handle(self.resID)
			end)
			;(nil)[4] = ffa.callFunc(function()
				SoraDCloseLoading()
				self.handle(self.resID)
			end)
			self:runAction(ffa.seq(nil))
		elseif serviceFunctions.getIDType(self.resID) == gIDType.WARFRAME then
			local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
			_ENV = ffa.seq(nil)
			ffa.seq(nil).key = "OpWarframeForg"
			mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.TO_BUILD_STATUE_BRAVE, ffa.seq(nil))
			_UPVALUE1_ = ffa.seq(nil)
			ffa.seq(nil)[1] = ffa.delay(0.08333333333333333)
			ffa.seq(nil)[2] = ffa.callFunc(function()
				SoraDRemoveAllPrePanelFromManager(self.parent)
			end)
			ffa.seq(nil)[3] = ffa.callFunc(function()
				SoraDRemoveAllPrePanelFromManager(self.parent)
			end)
			self:runAction(ffa.seq(ffa.seq(nil)))
		else
			_ENV = self.runAction
			self.runAction.msg = "MESSAGE_SOLDIER_UI_TRAIN_SELECT"
			self.runAction.toID = self.resID
			SoraDSendMessage(self.runAction)
		end
		return
	end
	if self.isT13Army then
		local armyltCtrl = include("armyltCtrl")
		local bid = armyltCtrl.armyAttr(self.resID, "barrackID")
		_ENV = ffa.seq(ffa.seq(nil))
		ffa.seq(ffa.seq(nil)).bid = bid
		ffa.seq(ffa.seq(nil)).toIndex = 13
		uiManager:show("soldiersCampView", ffa.seq(ffa.seq(nil)))
		return
	end
	if self.resID == gIDDef.METEOR_CRYSTAL or self.resID == gIDDef.GILDED_CRYSTAL or self.resID == gIDDef.GILDED_CURE_ESSENCE then
		_ENV = uiManager
		uiManager.rid = self.resID
		uiManager.needResData = self.needResList
		uiManager:show("meteorBuyView", uiManager)
	else
		_ENV = uiManager
		uiManager.rid = self.resID
		uiManager.needResData = self.needResList
		uiManager:show("resourceBuyView", uiManager)
	end
end
return Btn_res

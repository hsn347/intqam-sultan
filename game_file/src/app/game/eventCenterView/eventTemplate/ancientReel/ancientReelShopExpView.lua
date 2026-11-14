local gametop = gModuleMgr.getObject("gametop")
local ancientReelCtrl = gametop.playertop_:getModule("ancientReelCtrl")
local ancientReelRead = include("ancientReelRead")
local ancientReelShopExpView = class("ancientReelShopExpView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("ancientReelShopExpView")
	end
	return target
end)
function ancientReelShopExpView:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("Ancient_reel_text_06"))
	self.single = SoraDGetChildByName(self, "panel_single")
	self.single:setVisible(false)
	self.scroll = SoraDGetChildByName(self, "ScrollView_award")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createSingle))
	self.progress_fg = SoraDGetChildByName(self, "LoadingBar_progress_fg")
	self.txtLevel = SoraDGetChildByName(self, "Text_level")
	self.txtLevelTitle = SoraDGetChildByName(self, "Text_level_title")
	self.txtLevelTitle:setString(i18n("common_text_748"))
	self.nodePro = SoraDGetChildByName(self, "node_probar_head")
	self.nodeProBarPreview = SoraDGetExtendChildFromCCSByName(self, "CCS_commonProgressBar_preview")
	self.nodeProBarPreview:setActionDelay(0.5)
	self.nodeProBarPreview:setHandle(function(data)
		local curPro = 100 * data.actionValue / data.maxValue
		local posx = SoraDFPosX(275 - curPro * 550 / 100, 0)
		self.nodePro:setPositionX(posx)
	end)
	_UPVALUE1_ = self.nodeProBarPreview
	self.nodeProBarPreview[1] = cca.fadeTo(0, 1.0)
	self.nodeProBarPreview[2] = cca.fadeTo(1.05, 0.5)
	self.nodeProBarPreview[3] = cca.fadeTo(1.05, 0.5)
	self.nodeProBarPreview[4] = cca.fadeTo(1.05, 0.5)
	local seq = cca.seq(self.nodeProBarPreview)
	self.spBar = SoraDGetChildByName(self, "Sprite_bar")
	self.spBar:runAction(cc.RepeatForever:create(seq))
	self:initData()
end
function ancientReelShopExpView:initData(data)
	self.itemList, _ENV = nil, nil
	print("刷新scroll-----")
	local exchangeList = ancientReelRead:getExpShopList()
	for _, v in ipairs(exchangeList) do
		_ENV = nil
		;(nil).itemdata = v
		table.insert(self.itemList, nil)
	end
	_ENV = table.insert
	table.insert.scroll = self.scroll
	self.scroll:updateScrollView(cc.size(640, 126), self.itemList, 1, table.insert)
	self.isGoldClass = ancientReelCtrl:isActiveGold()
	self:initLvInfo()
end
function ancientReelShopExpView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_ANCIENT_REEL_BUY_EXP", handler(self, self.sMsgBuySuccess))
end
function ancientReelShopExpView:createSingle()
	local ocx = self.single:clone()
	local single = include("ancientReelShopExpSingle").new(ocx)
	single:setVisible(true)
	single:setScroll(self.scroll)
	single:setParentView(self)
	single:setView(self)
	return ocx
end
function ancientReelShopExpView:showLoading()
	SoraDShowLoading(self, nil, nil, true)
end
function ancientReelShopExpView:closeLoading()
	SoraDCloseLoading(self)
end
function ancientReelShopExpView:sMsgBuySuccess(target, data)
	self:initData()
	self:closeLoading()
end
function ancientReelShopExpView:setLvInfo()
	local lv = ancientReelCtrl:getCurLevel()
	self.txtLevel:setString(lv)
	_UPVALUE2_ = lv
	lv[1] = self.txtLevel
	lv[2] = self.txtLevelTitle
	_ENV = self.txtLevelTitle
	self.txtLevelTitle[1] = 10
	_G.SoraDAlignNodeArrayOnBeginX(0, lv, not SoraDFIsRA(), self.txtLevelTitle)
	local cur, max = ancientReelCtrl:getCurLevelExp()
	self.nodeProBarPreview:stopAllActions()
	self.nodeProBarPreview:setInitState(false)
	ancientReelCtrl = false
	;(false).maxValue = max
	;(false).curValue = cur
	self.nodeProBarPreview:setProgressDate(false)
	self.nodeProBarPreview:setInitState(true)
	self.lv = lv
	self.cur = cur
	self.max = max
end
function ancientReelShopExpView:initLvInfo()
	if not self.lv then
		self:setLvInfo()
	else
		self:addAnimation()
	end
end
function ancientReelShopExpView:addAnimation()
	local ancientReelCtrl, actionArray
	local lv = ancientReelCtrl:getCurLevel()
	local cur, max = ancientReelCtrl:getCurLevelExp()
	table.insert(actionArray, cca.callFunc(function(...)
		self = nil
		;(nil).maxValue = max
		;(nil).curValue = self.cur
		self.nodeProBarPreview:setProgressDate(nil)
	end))
	if lv > self.lv then
		for i = 1, lv - self.lv do
			do
				table.insert(actionArray, cca.callFunc(function(...)
					self = nil
					;(nil).maxValue = max
					;(nil).curValue = max
					self.nodeProBarPreview:setProgressDate(nil)
				end))
				table.insert(actionArray, cca.delay(0.5))
				local curlv = self.lv + i
				table.insert(actionArray, cca.callFunc(function(...)
					self:showExpFullOnce(curlv)
					self.nodeProBarPreview:setInitState(false)
					self = false
					;(false).maxValue = max
					;(false).curValue = 0
					self.nodeProBarPreview:setProgressDate(false)
				end))
			end
		end
	end
	table.insert(actionArray, cca.callFunc(function(...)
		self = nil
		;(nil).maxValue = max
		;(nil).curValue = cur
		self.nodeProBarPreview:setProgressDate(nil)
	end))
	local seqProgress = cca.seq(actionArray)
	self.nodeProBarPreview:stopAllActions()
	self.nodeProBarPreview:runAction(seqProgress)
	self.lv = lv
	self.cur = cur
	self.max = max
end
function ancientReelShopExpView:showExpFullOnce(lv)
	print(lv, "lv")
	self.txtLevel:setString(lv)
	_UPVALUE2_ = self.txtLevel
	self.txtLevel[1] = cca.fadeTo(0, 0)
	self.txtLevel[2] = cca.fadeTo(0.11666666666666667, 1.0)
	self.txtLevel[3] = cca.fadeTo(0.5, 0)
	self.txtLevel[4] = cca.fadeTo(0.5, 0)
	self.txtLevel[5] = cca.fadeTo(0.5, 0)
	local seq = cca.seq(self.txtLevel)
	self.progress_fg:stopAllActions()
	self.progress_fg:runAction(seq)
end
return ancientReelShopExpView

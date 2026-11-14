local arenaltCtrl = include("arenaltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ArenaResultViewPanel = class("ArenaResultViewPanel", baseFguiPanel)
function ArenaResultViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ArenaResultViewPanel:ctor", self.viewName)
end
function ArenaResultViewPanel:onInit()
	print("=======ArenaResultViewPanel:onInit")
	self.fields.Button_ok:setString(i18n("common_text_054"))
	self.fields.Button_ok:addClickListener(handler(self, self.onClickClose))
	self.fields.Button_detail:setString(i18n("common_text_504"))
	self.fields.Button_detail:addClickListener(handler(self, self.btnDetailClick))
	self:initCards()
	if not SoraDFIsRA() then
		self.fields.Com_head1:fixPos()
		self.fields.Text_name1:fixPos()
		self.fields.Com_head2:fixPos()
		self.fields.Text_name2:fixPos()
		self.fields.Image_victory:setURL("frame_DrillGrounds_shengli04.png")
		self.fields.Image_lose:setURL("frame_DrillGrounds_shibai04.png")
	end
end
function ArenaResultViewPanel:onShow()
	print("=======ArenaResultViewPanel:onShow")
	local param = self.param
	self:initData(param.myInfo, param.enemyInfo, param.battleType)
end
function ArenaResultViewPanel:initCards()
	self.cardTab, _ENV = nil, nil
	for i = 1, 3 do
		local Com_card = self.fields["Com_card" .. i]
		Com_card:setTag(i)
		Com_card:addClickListener(handler(self, self.btnChooseClick))
		self.cardTab[i] = Com_card
	end
	local Com_effect = self.fields.Com_card1:getChild("Com_effect")
	local mv_1 = Com_effect:getChild("mv_1")
	mv_1:setAllFrameName("dh_budui1_%.2d.png", 0)
end
function ArenaResultViewPanel:doAction(index)
	local rIndex = 2
	for i, v in ipairs(self.cardTab) do
		if i == index then
			self:setCardItem(v, self.randFlipAward[1])
			v:getController("c1"):setSelectedIndex(1)
		else
			self:setCardItem(v, self.randFlipAward[rIndex])
			rIndex = rIndex + 1
		end
		v:getTransition("t0"):play()
	end
end
function ArenaResultViewPanel:btnChooseClick(EventContext)
	SoraDPlaySound()
	for __, v in ipairs(self.cardTab) do
		v:setTouchable(false)
	end
	self:doAction(EventContext:getSender():getTag())
end
function ArenaResultViewPanel:setCardItem(card, data)
	local itmeID = data and data.id or 100301
	local itmeCount = data and data.count or 1
	local Com_item = card:getChild("Com_item")
	Com_item:initData(itmeID, itmeCount)
end
function ArenaResultViewPanel:fightErr(target, redata)
	SoraDCloseLoading(self:displayObject())
	self:removeFromParent()
end
function ArenaResultViewPanel:playFailAni()
	SoraDPlaySound("innerbuildsound", 106)
	self.controllers.c1:setSelectedIndex(1)
	self.fields.Com_head1:setGrayed(true)
	self.fields.Usm_lose:setVisible(true)
	self.fields.Image_lose:setVisible(true)
end
function ArenaResultViewPanel:playSuccessAni()
	SoraDPlaySound("innerbuildsound", 106)
	self.controllers.c1:setSelectedIndex(0)
	self.fields.Com_head2:setGrayed(true)
	self.fields.Usm_victory:setVisible(true)
	self.fields.Image_victory:setVisible(true)
end
function ArenaResultViewPanel:resultBack(target, redata)
	SoraDCloseLoading(self:displayObject())
	self.fields.Com_dao:removeFromParent()
	if not redata.randFlipAward then
		_ENV = redata.randFlipAward
	end
	self.randFlipAward = redata.randFlipAward
	if redata.bWin then
		self:playSuccessAni()
		if redata.isRankUp then
			_ENV = self:displayObject()
			self:displayObject().rank = redata.rank
			self.fields.Text_tip:setString(i18n("arena_text_28", self:displayObject()))
		else
			self.fields.Text_tip:setString(i18n("arena_text_38_ROS"))
		end
	else
		self:playFailAni()
		self.fields.Text_tip:setString(i18n("arena_text_29"))
	end
	self.fields.Group:setVisible(true)
	self.transitions.t0:play()
	if not redata.report then
		_ENV = redata.report
	end
	self.repotyInfo = redata.report
	self.repotyInfo.bWin = redata.bWin
end
function ArenaResultViewPanel:initData(myInfo, enemyInfo, battleType)
	SoraDShowLoading(self:displayObject())
	_ENV = SoraDShowLoading
	SoraDShowLoading.myInfo = myInfo
	self.fightInfo, SoraDShowLoading.enemyInfo = SoraDShowLoading, enemyInfo
	self.battleType = battleType
	self:initView()
end
function ArenaResultViewPanel:initView()
	if next(self.fightInfo.myInfo) then
		local showName = arenaltCtrl.specialCreateName(self.fightInfo.myInfo, self.battleType ~= gArenaBattleType.ARENA_LOCAL)
		self.fields.Text_name1:setString(showName)
		self.fields.Com_head1:setHeadSprite(self.fightInfo.myInfo.iconID, self.fightInfo.myInfo.avatar)
	end
	if next(self.fightInfo.enemyInfo) then
		local showName = arenaltCtrl.specialCreateName(self.fightInfo.enemyInfo, self.battleType ~= gArenaBattleType.ARENA_LOCAL)
		self.fields.Text_name2:setString(showName)
		self.fields.Com_head2:setHeadSprite(self.fightInfo.enemyInfo.iconID, self.fightInfo.enemyInfo.avatar)
	end
end
function ArenaResultViewPanel:btnDetailClick()
	local arenaltCtrl = include("arenaltCtrl")
	local outData = arenaltCtrl.reportReMake(self.repotyInfo, self.battleType)
	local panel = SoraDCreatePanel("mailItemDetailView")
	panel:show()
	panel:hideRightAndLeftBtn()
	panel:initWithData(outData, "key")
	self:removeFromParent()
end
function ArenaResultViewPanel:onHide()
	if self.randFlipAward and next(self.randFlipAward) then
		SoraDPopGainItem(self.randFlipAward[1].id, self.randFlipAward[1].count)
	end
end
return ArenaResultViewPanel

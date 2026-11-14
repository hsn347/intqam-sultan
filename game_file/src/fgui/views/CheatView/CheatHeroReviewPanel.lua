local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CheatHeroReviewPanel = class("CheatHeroReviewPanel", baseFguiPanel)
function CheatHeroReviewPanel:ctor(...)
	CheatHeroReviewPanel.super.ctor(self, ...)
	print("CheatHeroReviewPanel:ctor", self.viewName)
end
function CheatHeroReviewPanel:onInit()
	print("=======CheatHeroReviewPanel:onInit")
	self.index = 1
	self.fields.Com_title:initData("英雄预览", handler(self, self.onClickClose))
	self.fields.Btn_left:addClickListener(handler(self, self.btnLHeroClick))
	self.fields.Btn_right:addClickListener(handler(self, self.btnRHeroClick))
end
function CheatHeroReviewPanel:onShow()
	print("=======CheatHeroReviewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.cfg = heroltCtrl.getAllHeroAndDressID()
	self:initView()
end
function CheatHeroReviewPanel:initView()
	local cfg, spineCfg = heroltCtrl:getHeroSpineCfg(self.cfg[self.index].dressID)
	local isUsm = cfg.isUsm or false
	self.fields.hero:initData(self.cfg[self.index].heroID)
	self.fields.hero:playOpacityAct()
	if not isUsm then
		self.fields.hero:playOffsetXAct(0.3)
	end
	self.fields.Text_ID:setString("英雄ID:" .. self.cfg[self.index].heroID .. ",装扮ID:" .. self.cfg[self.index].dressID)
	self.fields.Text_name:setString("英雄名字:" .. i18n(heroltCtrl.getHeroName(self.cfg[self.index].heroID)))
	local dressID = self.cfg[self.index].dressID
	local viewBg, isNewBg = heroltCtrl:getDressViewBg(dressID)
	if self.preViewBg and self.preViewBg ~= viewBg then
		self.fields.bg:setSpriteFrame(viewBg)
	else
		self.fields.bg:setSpriteFrame(viewBg)
	end
	local viewBgWidth = self.fields.bg:getWidth()
	if viewBgWidth < 852 then
		self.fields.bg:setScale(self:getWidth() / viewBgWidth)
	else
		self.fields.bg:setScale(1)
	end
	self.preViewBg = viewBg
end
function CheatHeroReviewPanel:btnLHeroClick()
	SoraDPlaySound()
	self.index = self.index - 1
	if self.index <= 0 then
		self.index = #self.cfg
	end
	self:initView()
end
function CheatHeroReviewPanel:btnRHeroClick()
	SoraDPlaySound()
	self.index = self.index + 1
	if self.index > #self.cfg then
		self.index = 1
	end
	self:initView()
end
return CheatHeroReviewPanel

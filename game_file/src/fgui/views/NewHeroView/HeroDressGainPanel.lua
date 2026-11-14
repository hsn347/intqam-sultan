local gametop = gModuleMgr.getObject("gametop")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local buffDesRead = include("buffDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroDressGainPanel = class("HeroDressGainPanel", baseFguiPanel)
function HeroDressGainPanel:ctor(...)
	self.super.ctor(self, ...)
	print("HeroDressGainPanel:ctor", self.viewName)
end
function HeroDressGainPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function HeroDressGainPanel:onInit()
	print("=======HeroDressGainPanel:onInit")
	self.heroID = self.proxy.param.heroID
	self.heroDressID = self.proxy.param.dressID
	self.fields.Text_ownBuff:setString(i18n("heroDress_text_002"))
	self.fields.Text_dressBuff:setString(i18n("heroDress_text_003"))
	self.fields.Node_criOnce:setCompleteCallback(function()
		self.fields.Node_criOnce:clearEffectOnly()
	end)
end
function HeroDressGainPanel:onShow()
	print("=======HeroDressGainPanel:onShow")
	local height = self:getHeight()
	self.fields.Node_criOnce:setScale(height / 900)
	self.fields.Node_cri:setScaleX(self:getWidth() / 640)
	self.fields.Bottom_Node_cri:setScaleX(self:getWidth() / 640)
	self:initData()
end
function HeroDressGainPanel:initData()
	local bgName, isNew = heroltCtrl:getDressViewBg(self.heroDressID)
	self.fields.bg:setSpriteFrame(bgName)
	local viewBgWidth = self.fields.bg:getWidth()
	if viewBgWidth < 852 then
		self.fields.bg:setScale(self:getWidth() / viewBgWidth)
	else
		self.fields.bg:setScale(1)
	end
	self.fields.Sprite_name:setSpriteFrame(heroltCtrl.getHeroNamePng(self.heroID))
	self.fields.Text_dressName:setSpriteFrame(heroltCtrl:getDressNameLongPNG(self.heroDressID))
	self:updateSpine()
	self:loadBuff()
end
function HeroDressGainPanel:updateSpine()
	local cfg, spineCfg = heroltCtrl:getHeroSpineCfg(self.heroDressID)
	local isUsm = cfg.isUsm or false
	self.fields.Spine:setVisible(not isUsm)
	self.fields.Usm:setVisible(isUsm)
	if isUsm then
		if cfg.maxChunkSize then
			self.fields.Usm:setMaxChunkSize(cfg.maxChunkSize)
		end
		self.fields.Usm:setEffectPath(spineCfg)
		self.fields.Usm:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		self.fields.Usm:setScale(cfg.detail[1])
		self.fields.Usm:setUsmAP(cc.p(0.5, 0))
		self.fields.Usm:setUsmPos(cc.p(cfg.detail[2], cfg.detail[3]))
	else
		self.fields.Spine:setEffectPath(spineCfg)
		self.fields.Spine:setScale(cfg.detail[1])
		self.fields.Spine:setSpinePos(cc.p(cfg.detail[2], cfg.detail[3]))
	end
end
function HeroDressGainPanel:loadBuff()
	local ownBuff = heroltCtrl:getOwnBuff(self.heroDressID)
	local dressBuff = heroltCtrl:getDressBuff(self.heroDressID)
	local len = math.max(#ownBuff, #dressBuff)
	local height = len * 42
	for i = 1, len do
		local single = fgui.UIPackage:createObject("NewHeroView", "Com_buffSingle")
		single:addTo(self.fields.Node_Buff)
		single:setPosition(0, 0)
		single:runAction(ffa.exponentialOut(ffa.moveTo(0.8, 0, (i - 1) * 42)))
		local _fields = fguiHelper.get_fields(single)
		_fields.Image_l:setVisible(i % 2 == 1)
		_fields.Image_r:setVisible(i % 2 == 1)
		_fields.Text_buffName1:fixPos()
		_fields.Text_buffVal1:fixPos()
		_fields.lace_1:fixPos()
		_fields.Text_buffName2:fixPos()
		_fields.Text_buffVal2:fixPos()
		_fields.lace_2:fixPos()
		if i <= #ownBuff then
			_fields.Text_buffName1:setString(buffDesRead.getTitleBase(ownBuff[i].id))
			_fields.Text_buffVal1:setString(buffDesRead.getTitleValueWithValue(ownBuff[i].id, ownBuff[i].value))
		else
			_fields.Text_buffName1:setString("")
			_fields.Text_buffVal1:setString("")
		end
		_fields.lace_1:setVisible(i <= #ownBuff)
		if i <= #dressBuff then
			_fields.Text_buffName2:setString(buffDesRead.getTitleBase(dressBuff[i].id))
			_fields.Text_buffVal2:setString(buffDesRead.getTitleValueWithValue(dressBuff[i].id, dressBuff[i].value))
		else
			_fields.Text_buffName2:setString("")
			_fields.Text_buffVal2:setString("")
		end
		_fields.lace_2:setVisible(i <= #dressBuff)
	end
	self.fields.Node_Buff:setContentSize(cc.size(640, height))
end
return HeroDressGainPanel

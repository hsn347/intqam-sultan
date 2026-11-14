local publicRead = include("publicRead")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroDressPreviewPanel = class("HeroDressPreviewPanel", baseFguiPanel)
function HeroDressPreviewPanel:ctor(...)
	HeroDressPreviewPanel.super.ctor(self, ...)
	print("HeroDressPreviewPanel:ctor", self.viewName)
end
function HeroDressPreviewPanel:onInit()
	print("=======HeroDressPreviewPanel:onInit")
	self.Text_own = SoraDCreateTimerLabel(self, self.fields.Text_own)
	self.Spine = self.fields.bg:getChild("Spine")
	self.Usm = self.fields.bg:getChild("Usm")
	self.bg = self.fields.bg:getChild("bg")
	self.fields.Lab_ownAttr:setString(i18n("heroDress_text_002"))
	self.fields.Lab_wearAttr:setString(i18n("heroDress_text_003"))
	self.fields.List_own:setItemRenderer(handler(self, self.onOwnRender))
	self.fields.List_wear:setItemRenderer(handler(self, self.onWearRender))
end
function HeroDressPreviewPanel:onOwnRender(index, obj)
	obj:initData(self.ownBuff[index + 1], index + 1)
end
function HeroDressPreviewPanel:onWearRender(index, obj)
	obj:initData(self.dressBuff[index + 1], index + 1)
end
function HeroDressPreviewPanel:onShow()
	print("=======HeroDressPreviewPanel:onShow")
	self.itemID = self.param.itemID
	local result = backpackltCtrl:getResult(self.itemID)
	self.dressID = result[1]
	self.fields.Panel_bg:setString(publicRead.getName(self.itemID))
	local ret, remainTime, foreverCount, curCount = backpackCtrl:getOwnDressInfo(self.itemID)
	if ret then
		if 0 < remainTime then
			self.Text_own:setTimeLast(function(time)
				_ENV = nil
				;(nil).time = time
				return i18n("common_text_4936", nil)
			end)
			self.Text_own:setTimeEndListener(function()
				self = nil
				;(nil).num = string.formatnumberthousands(curCount)
				self.Text_own:setString(i18n("skin_text_23", nil))
			end)
			self.Text_own:beginTime(remainTime)
			self.Text_own:setColor("#70C723")
		else
			self.Text_own:setString(i18n("common_text_4831"))
			self.Text_own:setColor("#E02B2B")
		end
	elseif 0 < foreverCount then
		self.Text_own:setString(i18n("common_text_4937"))
		self.Text_own:setColor("#70C723")
	else
		_ENV = i18n("common_text_4937")
		i18n("common_text_4937").num = string.formatnumberthousands(curCount)
		self.Text_own:setString(i18n("skin_text_23", i18n("common_text_4937")))
		self.Text_own:setColor("#E02B2B")
	end
	self.ownBuff = heroltCtrl:getOwnBuff(self.dressID)
	self.dressBuff = heroltCtrl:getDressBuff(self.dressID)
	self.fields.List_own:setNumItems(#self.ownBuff)
	self.fields.List_wear:setNumItems(#self.dressBuff)
	self:initHeadSpine()
end
function HeroDressPreviewPanel:initHeadSpine()
	local cfg, spineCfg = heroltCtrl:getHeroSpineCfg(self.dressID)
	local isUsm = cfg.isUsm or false
	self.Spine:setVisible(not isUsm)
	self.Usm:setVisible(isUsm)
	if isUsm then
		if cfg.maxChunkSize then
			self.Usm:setMaxChunkSize(cfg.maxChunkSize)
		end
		self.Usm:setEffectPath(spineCfg)
		self.Usm:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		self.Usm:setScale(cfg.share[1])
		self.Usm:setUsmAP(cc.p(0.5, 0))
		self.Usm:setUsmPos(cc.p(cfg.share[2], cfg.share[3]))
	else
		self.Spine:setEffectPath(spineCfg)
		self.Spine:setScale(cfg.share[1])
		self.Spine:setSpinePos(cc.p(cfg.share[2], cfg.share[3]))
	end
	local viewBg, isNewBg = heroltCtrl:getDressViewBg(self.dressID)
	self.bg:setURL(viewBg)
end
return HeroDressPreviewPanel

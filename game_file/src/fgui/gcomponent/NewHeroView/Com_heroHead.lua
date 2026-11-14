local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local gametop = gModuleMgr.getObject("gametop")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_heroHead = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/Com_heroHead", Com_heroHead)
function Com_heroHead:onInit()
end
function Com_heroHead:onShow()
end
function Com_heroHead:initData(heroID)
	self.heroID = tonumber(heroID)
	self.heroDesInfo = heroltCtrl.getHeroInfo(self.heroID)
	self:initView()
end
function Com_heroHead:setHeadBg(quality)
	if quality then
		self.fields.Sprite_headBg:setSpriteFrame(heroltCtrl.getBg(quality))
	else
		self.fields.Sprite_headBg:setSpriteFrame(heroltCtrl.getBg(gHeroQuality.WHITE))
	end
end
function Com_heroHead:initView(...)
	local dressID = heroCtrl:getHeroDressSeting(self.heroID)
	if dressID and not heroltCtrl:isDefaultDress(dressID) then
		self.fields.Sprite_head:setSpriteFrame(heroltCtrl.heroDressCfg[dressID].herIcon)
	else
		self.fields.Sprite_head:setSpriteFrame(heroltCtrl.herosInfo[self.heroID].herIcon)
	end
	self.fields.Sprite_class:setSpriteFrame(heroltCtrl.getHeroClassTypeInfo(self.heroID).icon)
end
function Com_heroHead:setSpHead(dressID)
	self.fields.Sprite_head:setSpriteFrame(heroltCtrl.heroDressCfg[dressID].herIcon)
end
return Com_heroHead

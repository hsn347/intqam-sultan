local palaceInfoRead = include("palaceInfoRead")
local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_camp = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://RoaringFlame/Com_camp", Com_camp)
function Com_camp:onInit()
	self.fields.red:setAllFrameName("G_9001674_glow_%.2d.png", 0)
	self.fields.green:setAllFrameName("G_9001674_glow_%.2d.png", 0)
	self.fields.yellow:setAllFrameName("G_9001674_glow_%.2d.png", 0)
	self.fields.blue:setAllFrameName("G_9001674_glow_%.2d.png", 0)
	self.fields.purple:setAllFrameName("G_9001674_glow_%.2d.png", 0)
	self.fields.Text_match:setString(i18n("flames_dunes_text3"))
	self.fields.icon_self:setVisible(false)
end
function Com_camp:onShow()
end
function Com_camp:initData(index, data)
	self.fields.icon_self:setVisible(false)
	if data.err == gErrDef.Err_None then
		local info = roaringFlameWarCtrl:getMatchResult(index)
		if info and info.kid > 0 then
			self:setVisible(true)
			local curState = roaringFlameWarCtrl:getCurState()
			local isMatch = curState == ROARING_FLAME_WAR_STATE.MATCH
			self.controllers.c1:setSelectedIndex(isMatch and 0 or 1)
			self.controllers.c2:setSelectedIndex(index - 1)
			if not isMatch then
				local cfg = roaringFlameWarRead.getCampCfg(index)
				self.fields.Text_name:setString(i18n(cfg.name))
				self.fields.Text_name:setColor(SoraDHtmlColor2RGB(cfg.color or "#00FFFF"))
				_ENV = SoraDHtmlColor2RGB(cfg.color or "#00FFFF")
				SoraDHtmlColor2RGB(cfg.color or "#00FFFF").kid = info.kid
				SoraDHtmlColor2RGB(cfg.color or "#00FFFF").name = info.kingdomName
				self.fields.Text_kingdom:setString(i18n("#%{kid}  %{name}", SoraDHtmlColor2RGB(cfg.color or "#00FFFF")))
				self.fields.icon:setSpriteFrame(palaceInfoRead.getIcon(info.placeModel))
				self.fields.icon_self:setVisible(info.kid == SoraDGetCtrl("lordInfoCtrl"):getMapSourceKid())
			end
		else
			self:setVisible(false)
		end
	else
		self:setVisible(true)
		self.controllers.c1:setSelectedIndex(0)
	end
end
return Com_camp

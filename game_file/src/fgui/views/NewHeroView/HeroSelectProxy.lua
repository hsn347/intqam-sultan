local baseProxy = require("fgui.base.baseProxy")
local HeroSelectProxy = class("HeroSelectProxy", baseProxy)
function HeroSelectProxy:onRegisterEvent()
	print("=======HeroSelectProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_NOTICEHERO", handler(self, self.stateChange))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_DRESS_UPDATE", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_STATE_UPDATE", handler(self, self.noticeRefreshByID))
end
function HeroSelectProxy:stateChange(target, redata)
	local affectHeros = redata.affectHeros
	local selectedHeros = self.view.fields.heroBanner:exportHeros()
	for _, v in ipairs(selectedHeros) do
		if affectHeros[tostring(v)] then
			self.view.fields.heroBanner:subHero(v)
			self.view:bannerRemoveCallBack(v)
			SoraDShowMsgTip(i18n("hero_text_70"))
		end
	end
end
function HeroSelectProxy:initView()
	self.view:initView()
end
function HeroSelectProxy:noticeRefreshByID(target, redata)
	if redata and redata.heroID then
		SoraDShowHeroDetailView(tonumber(redata.heroID))
	end
	self.view:initScrollList()
end
return HeroSelectProxy

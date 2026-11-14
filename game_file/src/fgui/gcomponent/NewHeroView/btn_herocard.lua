local heroCtrl = SoraDGetCtrl("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local btn_herocard = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://NewHeroView/btn_herocard", btn_herocard)
function btn_herocard:onInit()
	self.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.fields.Text_using:setString(i18n("privilege_text_130"))
end
function btn_herocard:onShow()
end
function btn_herocard:initData(dressID)
	self.dressID = dressID
	self.heroID = math.floor(dressID / 100)
	print("dressID", dressID, self.heroID)
	self.fields.frame_hero_bg:setURL(heroltCtrl:getDressBeiJing(self.dressID))
	self.fields.sprite_sheer:setURL(heroltCtrl:getDressZhezhao(self.dressID))
	self.fields.img_gem:setURL(heroltCtrl:getDressBaoshi(self.dressID))
	self.fields.Sprite_head:setURL(heroltCtrl:getDressCard(self.dressID))
	local isOwn = heroCtrl:isOwnDressID(self.heroID, self.dressID)
	local isWear = heroCtrl:isWearDressID(self.heroID, self.dressID)
	local isLimited = heroCtrl:isLimitedDress(self.heroID, self.dressID)
	if isOwn then
		if isWear then
			if isLimited then
				self.controllers.c1:setSelectedIndex(2)
				self.Text_time:beginTime(heroCtrl:getDressLimitedTime(self.heroID, self.dressID))
			else
				self.controllers.c1:setSelectedIndex(1)
			end
		else
			self.controllers.c1:setSelectedIndex(0)
		end
	else
		self.controllers.c1:setSelectedIndex(3)
		if heroCtrl:isHeroHaveDressActive(self.heroID, self.dressID) then
			self.fields.Com_Lock:getController("c1"):setSelectedIndex(1)
			self.fields.Com_Lock:getTransition("t0"):play(-1, 0, 0, -1)
		else
			self.fields.Com_Lock:getController("c1"):setSelectedIndex(0)
		end
	end
end
return btn_herocard

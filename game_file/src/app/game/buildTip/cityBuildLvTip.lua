local cityBuildLvTip = class("cityBuildLvTip", function(target)
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
function cityBuildLvTip:ctor()
	self.spriteBuildLvBg = SoraDGetChildByName(self, "spriteBuildLvBg")
	self.spriteBuildUp = SoraDGetChildByName(self, "spriteBuildUp")
	self.textLv = SoraDGetChildByName(self, "textLv")
	self.spriteBuildUp:setVisible(false)
end
function cityBuildLvTip:showImgUp()
	if nil == self.spriteBuildUp then
		return
	end
	self.spriteBuildUp:setVisible(true)
end
function cityBuildLvTip:hideImgUp()
	if nil == self.spriteBuildUp then
		return
	end
	self.spriteBuildUp:setVisible(false)
end
function cityBuildLvTip:setLv(buildLv)
	if nil == self.textLv then
		return
	end
	_ENV = nil
	;(nil).commonStr = tostring(buildLv)
	local strLv = i18n("common_text_034", nil)
	self.textLv:setString(strLv)
end
function cityBuildLvTip:setIsCanUpgrade(isCanUpgrade)
	if isCanUpgrade then
		self.spriteBuildUp:setVisible(true)
	else
		self.spriteBuildUp:setVisible(false)
	end
end
return cityBuildLvTip

local achiDesRead = include("achiDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_achi = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_achi", Com_achi)
function Com_achi:onInit()
end
function Com_achi:onShow()
end
function Com_achi:initData(data)
	self.fields.achi:clearContent()
	local spriteAchi = achiDesRead.getShowMedalPic(data.showAchieveID, data.showMetalID)
	spriteAchi:setPosition(100, 100)
	self.fields.achi:setContent(spriteAchi)
	self.fields.title:setString(i18n(achiDesRead.getMedalById(data.showMetalID).medalName))
end
function Com_achi:initPopData(data)
	self.fields.achi:clearContent()
	local spriteAchi = achiDesRead.getShowMedalPic(data.medalID, data.medalID, data.star)
	spriteAchi:setPosition(100, 100)
	self.fields.achi:setContent(spriteAchi)
	self.fields.title:setVisible(false)
end
return Com_achi

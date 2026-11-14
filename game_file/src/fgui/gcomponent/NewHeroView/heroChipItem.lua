local gametop = gModuleMgr.getObject("gametop")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local heroChipItem = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://NewHeroView/heroChipItem", heroChipItem)
function heroChipItem:onInit()
	self.fields.n6:setAllFrameName("dh_jinengyj01_%.3d.png", 0)
	self:addClickListener(handler(self, self.onClick))
end
function heroChipItem:onShow()
end
function heroChipItem:initData(heroID, itemNum, needNum, itemID)
	self.heroID = heroID
	self.itemID = itemID
	self.needNum = needNum
	self.fields.Sprite_icon:setIcon(heroltCtrl.getHeroChip(heroID))
	self.isEnough = needNum <= itemNum
	self.fields.n6:setVisible(self.isEnough)
	if not self.isEnough then
		itemNum = fguiHelper.getColorString("#FF0000", itemNum)
	end
	heroltCtrl = heroltCtrl.getHeroChip(heroID)
	heroltCtrl.getHeroChip(heroID).total = needNum
	heroltCtrl.getHeroChip(heroID).member = itemNum
	self.fields.Text_count:setString(i18n("common_text_155", heroltCtrl.getHeroChip(heroID)))
end
function heroChipItem:onClick()
	if self.isEnough then
		SoraDPlaySound()
		local activeTime = heroltCtrl:getUpgradeActiveTime(self.heroID) or 0
		if activeTime == 0 then
			heroCtrl:recruitReq(self.heroID)
		elseif activeTime > serviceFunctions.systemTime() then
			_ENV = nil
			;(nil).time = SoraDConvertSecondToString(activeTime - serviceFunctions.systemTime())
			SoraDShowMsgTip(i18n("notactivate_text_3", nil))
		else
			heroCtrl:recruitReq(self.heroID)
		end
	else
		_ENV = self.heroID
		self.heroID.itemID = self.itemID
		self.heroID.needCount = self.needNum
		uiManager:show("newHeroGainChipMethodView", self.heroID)
	end
end
return heroChipItem

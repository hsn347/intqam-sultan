local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_heroShow = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://LuckyFalcon/Com_heroShow", Com_heroShow)
function Com_heroShow:onInit()
end
function Com_heroShow:onShow()
end
function Com_heroShow:initData(heroID)
	local heroDesInfo = heroltCtrl.getHeroInfo(heroID)
	self.fields.bg:setSpriteFrame(heroltCtrl.getHeroCardBg(heroID))
	self.fields.Icon_hero:setSpriteFrame(heroDesInfo.heroCard)
	local maxQuality = heroltCtrl:getHeroAwakeMaxQuality(heroID)
	self.fields.frame_quality:setSpriteFrame(heroltCtrl.getCardFrmBg(maxQuality))
	local heroInfo = heroCtrl:getHeroInfoByID(heroID)
	if not heroInfo then
		self.controllers.c1:setSelectedIndex(1)
		local itemNum, needNum, itemID = heroltCtrl:judgeUpgradeItem(heroID)
		heroltCtrl = heroltCtrl.getCardFrmBg(maxQuality)
		heroltCtrl.getCardFrmBg(maxQuality).member = itemNum
		heroltCtrl.getCardFrmBg(maxQuality).total = needNum
		self.fields.Node_chip:setText(i18n("common_text_155", heroltCtrl.getCardFrmBg(maxQuality)))
		self.fields.Node_chip:setTitleColor(needNum <= itemNum and cc.c3b(0, 182, 42) or cc.c3b(182, 42, 40))
		self.fields.Node_chip:setIcon(heroltCtrl.getHeroChip(heroID))
	else
		self.controllers.c1:setSelectedIndex(0)
	end
end
return Com_heroShow

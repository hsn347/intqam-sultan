local publicRead = include("publicRead")
local buffDesRead = include("buffDesRead")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Lab_chipDes = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://NewHeroView/Lab_chipDes", Lab_chipDes)
function Lab_chipDes:onInit()
	self.fields.Text_skillTip:setString(i18n("hero_text_28"))
	self.fields.Text_skillColor:setString(i18n("hero_text_29"))
	self.fields.Text_des:fixPos()
	self.fields.Text_class:fixPos()
	self.fields.Text_skillTip:fixPos()
	self.fields.Text_skillColor:fixPos()
	for i = 1, 4 do
		self.fields["Text_skill" .. i]:fixPos()
	end
end
function Lab_chipDes:onShow()
end
function Lab_chipDes:initData(heroID, itemID)
	local heroViewInfo = heroltCtrl.getHeroInfo(heroID)
	local rarity = heroltCtrl:getHeroRarity(heroID)
	local heroClassInfo = heroltCtrl.getHeroClassTypeInfo(heroID)
	local _, needNum, itemID = heroltCtrl:judgeUpgradeItem(heroID)
	local itemName = publicRead.getName(itemID)
	local heroInfo = heroltCtrl.getHeroInfo(heroID)
	heroltCtrl = nil
	;(nil).num = needNum
	;(nil).chip = itemName
	;(nil).hero = i18n(heroInfo.herName)
	self.fields.Text_des:setString(i18n("hero_text_51", nil))
	self.fields.Text_skillColor:setString(rarity >= gHeroRarity.ORANGE and i18n("hero_text_125") or i18n("hero_text_29"))
	self.fields.Text_skillColor:setColor(rarity >= gHeroRarity.ORANGE and cc.c3b(255, 0, 0) or cc.c3b(255, 255, 0))
	if type(heroViewInfo.heroType) == "number" then
		heroltCtrl = 255
		;(255).heroType = i18n(heroClassInfo.typename)
		self.fields.Text_class:setString(i18n("hero_text_27", 255))
	elseif type(heroViewInfo.heroType) == "table" then
		local heroTypeStr = ""
		for k, v in ipairs(heroViewInfo.heroType) do
			heroTypeStr = heroTypeStr .. " " .. i18n(heroltCtrl.getHeroClassTypeName(v))
		end
		heroltCtrl = i18n("hero_text_27", 255)
		i18n("hero_text_27", 255).heroType = heroTypeStr
		self.fields.Text_class:setString(i18n("hero_text_27", i18n("hero_text_27", 255)))
	end
	local skills = heroltCtrl.getMaxQualitySkills(heroID)
	for i = 1, 4 do
		local _info = skills[i]
		if _info then
			self.fields["Text_skill" .. i]:setVisible(true)
			self.fields["Text_skill" .. i]:setString(buffDesRead.getTitleWithValue(_info.buffType, _info.buffValue))
		else
			self.fields["Text_skill" .. i]:setVisible(false)
		end
	end
end
return Lab_chipDes

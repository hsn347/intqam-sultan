local godArmsRuneCtrl = SoraDGetCtrl("godArmsRuneCtrl")
local artifactRuneRead = include("artifactRuneRead")
local baseComponent = require("fgui.base.baseComponent")
local RuneQuickSetItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Chaser/RuneQuickSetItem", RuneQuickSetItem)
function RuneQuickSetItem:onInit()
	self.fields.Button_copy:setString(i18n("Weapon_Rune_tips_087"))
	self.fields.Button_copy:addClickListener(handler(self, self.onCopyClick))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_none:setString(i18n("Weapon_Rune_tips_110"))
	self:fixChildrenPos()
	self.fields.n2:fix()
end
function RuneQuickSetItem:onShow()
end
function RuneQuickSetItem:onItemRenderer(index, obj)
	obj:initData(self.curRuneList[index + 1])
end
function RuneQuickSetItem:initData(setID, weaponID, group, parent)
	self.weaponID = weaponID
	self.group = group
	self.setID = setID
	self.parent = parent
	if self.setID == 1 then
		self.fields.Text_name:setString(i18n("common_text_4345"))
	else
		local name = godArmsRuneCtrl:getArmGroupName(self.weaponID, self.setID)
		self.fields.Text_name:setString(name)
	end
	self.setList = godArmsRuneCtrl:getArmDetailList(self.weaponID, self.setID)
	dump(self.setList, "self.setList====")
	self.curRuneList, _ENV = dump, dump
	for k, v in pairs(self.setList) do
		if tonumber(k) and v ~= 0 then
			local runeData = godArmsRuneCtrl:getRuneInfo(v)
			local info = artifactRuneRead.getRuneInfo(runeData.rid)
			local lvCfg = artifactRuneRead.getRuneLvCfg(info.ExpGrowingType, runeData.level)
			if not runeData.extraProperty then
				local _ENV, extraProperty = runeData.extraProperty, runeData.extraProperty
			end
			_ENV = i18n("common_text_4345")
			i18n("common_text_4345").rid = runeData.rid
			i18n("common_text_4345").uid = v
			i18n("common_text_4345").exp = runeData.exp
			i18n("common_text_4345").isLock = runeData.isLock
			i18n("common_text_4345").class = lvCfg.Class
			i18n("common_text_4345").season = info.Season
			i18n("common_text_4345").level = runeData.level
			i18n("common_text_4345").cLevel = lvCfg.Level
			i18n("common_text_4345").heritType = info.HeritType
			i18n("common_text_4345").runeType = info.RuneType
			i18n("common_text_4345").extraProperty = extraProperty
			i18n("common_text_4345").tempExtraProperty = runeData.tempExtraProperty
			table.insert(self.curRuneList, i18n("common_text_4345"))
		end
	end
	table.sort(self.curRuneList, function(a, b)
		if a.season == b.season then
			if a.class == b.class then
				if a.level == b.level then
					if a.runeType == b.runeType then
						return a.rid < b.rid
					else
						return a.runeType < b.runeType
					end
				else
					return a.level > b.level
				end
			else
				return a.class > b.class
			end
		else
			return a.season > b.season
		end
	end)
	self.fields.List:setNumItems(#self.curRuneList)
	self.fields.Text_none:setVisible(#self.curRuneList == 0)
end
function RuneQuickSetItem:onCopyClick()
	SoraDPlaySound()
	print("self.setID,self.group====", self.setID, self.group)
	if artifactRuneRead.isRuneSetLock(self.setID - 1) or artifactRuneRead.isRuneSetLock(self.group - 1) then
		SoraDShowMsgTip(i18n("Weapon_Rune_tips_095"))
	else
		_ENV = i18n("Weapon_Rune_tips_095")
		i18n("Weapon_Rune_tips_095").content = i18n("Weapon_Rune_tips_088")
		i18n("Weapon_Rune_tips_095").confirmFunc = function()
			local groupList = godArmsRuneCtrl:getArmGroupList(self.weaponID)
			if next(groupList[self.setID].detail) then
				godArmsRuneCtrl:sendGroupSave(self.weaponID, self.group, groupList[self.setID].detail)
				self.parent:close()
			else
				SoraDShowMsgTip(i18n("Weapon_Rune_tips_091"))
			end
		end
		uiManager:show("MessageBox", i18n("Weapon_Rune_tips_095"))
	end
end
return RuneQuickSetItem

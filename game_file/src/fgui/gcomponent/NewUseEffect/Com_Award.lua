local publicRead = include("publicRead")
local gametop = gModuleMgr.getObject("gametop")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_Award = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewUseEffect/Com_Award", Com_Award)
function Com_Award:onInit()
	self.itemList2, _ENV, self.itemList, _ENV = nil, nil, nil, nil
	self.fields.List_1:setItemRenderer(handler(self, self.onItemRenderer1))
	self.fields.List_2:setItemRenderer(handler(self, self.onItemRenderer2))
end
function Com_Award:onShow()
end
function Com_Award:initData(itemID)
	local ret, show, isShow = backpackltCtrl:getRandomGiftShowItems(itemID)
	if show == 1 then
		self.fields.Title_1:setString(i18n("common_text_4279"))
	elseif show == 2 then
		self.fields.Title_1:setString(i18n("common_text_4280"))
	elseif show == 3 then
		self.fields.Title_1:setString(i18n("common_text_4281"))
	else
		local itemType = backpackltCtrl:getResultType(itemID)
		if itemType == gItemEffectDef.OPTIONAL_HERO then
			self.fields.Title_1:setString(i18n("Endless_trial_text_22") .. i18n("common_text_4362"))
		elseif itemType == gItemEffectDef.ACTIVITY_9001687_GIFT then
			self.fields.Title_1:setString(i18n("valueTreasure_text_05"))
		else
			self.fields.Title_1:setString(i18n("common_text_4362"))
		end
	end
	table.sort(ret, function(l, r)
		if publicRead.getQuality(l.id) == publicRead.getQuality(r.id) then
			if l.count == r.count then
				return l.id > r.id
			else
				return l.count > r.count
			end
		else
			return publicRead.getQuality(l.id) > publicRead.getQuality(r.id)
		end
	end)
	self.itemList = ret
	self.fields.List_1:setNumItems(#self.itemList)
	self.fields.List_1:resizeToFit(#self.itemList)
	self.itemList2 = backpackltCtrl:getExtraItems(itemID)
	if next(self.itemList2) then
		dump(self.itemList2, "itemList2")
		self.controllers.c1:setSelectedIndex(1)
		self.fields.List_2:setNumItems(#self.itemList2)
		self.fields.List_2:resizeToFit(#self.itemList2)
		self.fields.Title_2:setString(i18n("common_text_4711"))
	end
end
function Com_Award:onItemRenderer2(index, target)
	target:initData(self.itemList2[index + 1], false, true)
	target:showbg(index % 2 == 1)
end
function Com_Award:onItemRenderer1(index, target)
	target:initData(self.itemList[index + 1], false, true)
	target:showbg(index % 2 == 1)
end
return Com_Award

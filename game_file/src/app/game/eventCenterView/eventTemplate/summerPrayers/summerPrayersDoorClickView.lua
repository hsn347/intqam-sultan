local publicRead = include("publicRead")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local summerPrayRead = include("summerPrayRead")
local summerPrayersDoorClickView = class("summerPrayersDoorClickView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("summerPrayersDoorClickView")
end)
function summerPrayersDoorClickView:ctor(properties)
	self.panelCut = SoraDGetChildByName(self, "Center_Panel_cut")
	self.textName = SoraDGetChildByName(self.panelCut, "Text_name")
	self.textTitleInfo = SoraDGetChildByName(self.panelCut, "Text_TitleInfo")
	self.textTitleInfo:setString(i18n("pray_text_28"))
	self.scroll = SoraDGetChildByName(self.panelCut, "ScrollView")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createScrollSingle))
	self.scroll:setSingleRefresh(handler(self, self.refreshScrollSingle))
	self.scroll:setIsRight(SoraDFIsRA())
	self.nodeAward = SoraDGetChildByName(self, "Node_Award")
	self.imgIcon = SoraDGetChildByName(self.panelCut, "Image_icon")
	self.nodeSingle = SoraDGetChildByName(self, "Node_Single")
end
function summerPrayersDoorClickView:initData(index)
	self.index = index
	local config = summerPrayRead.getBoxConfigByOrder(index)
	dump(config, "reward", 10)
	self.textName:setString(i18n(publicRead.getName(config.packreward1[1].id)))
	self.imgIcon:loadTexture(publicRead.getIcon(config.packreward1[1].id), ccui.TextureResType.plistType)
	local ret = backpackltCtrl:getRandomGiftShowItems(config.packreward1[1].id)
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
	summerPrayRead = i18n(publicRead.getName(config.packreward1[1].id))
	i18n(publicRead.getName(config.packreward1[1].id)).scroll = self.scroll
	i18n(publicRead.getName(config.packreward1[1].id)).parent = self
	self.scroll:updateScrollView(cc.size(530, 100), ret, 1, i18n(publicRead.getName(config.packreward1[1].id)))
end
function summerPrayersDoorClickView:createScrollSingle()
	local single = self.nodeSingle:clone()
	return single
end
function summerPrayersDoorClickView:refreshScrollSingle(single, data)
	SoraDGetChildByName(single, "Image_Bg"):setVisible(single:getTag() % 2 == 0)
	local item = SoraDGetExtendChildFromCCSByName(single, "CCS_commonItemAward")
	SoraDGetChildByName(single, "Text_ItemNum"):setString(string.format("x%d", data.count))
	SoraDGetChildByName(single, "Text_ItemName"):setString(publicRead.getName(data.id))
	item:setOwnView(self)
	item:setRealScale(0.9)
	item:initData(data.id, data.count)
end
return summerPrayersDoorClickView

local publicRead = include("publicRead")
local gametop = gModuleMgr.getObject("gametop")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local cheatItemWindow = class("cheatItemWindow", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("cheatItemWindow")
	end
	return target
end)
function cheatItemWindow:ctor()
	self:bindBtnClose()
	self.onceLoad = 5
	self.curPage = 1
	self.totalPage = 1
	self.itemDataList, _ENV, self.itemIDList, _ENV, self.style = self.bindBtnClose, self.bindBtnClose, self.bindBtnClose, self.bindBtnClose, 1
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:hideTitle()
	self.Node_editbox = SoraDGetChildByName(self, "Node_editbox")
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView_item")
	self.scroll:setInnerContainerSize(cc.size(self.scroll:getContentSize().width, self.onceLoad * 100))
	self.text_page = SoraDGetChildByName(self, "Text_page")
	self.btn_pre = SoraDGetChildByName(self, "Button_pre")
	self.btn_next = SoraDGetChildByName(self, "Button_next")
	self.btn_pre:addTouchEventListener(handler(self, self.btnPreClick))
	self.btn_next:addTouchEventListener(handler(self, self.btnNextClick))
	self.editbox_item = ccui.EditBox:create(cc.size(320, 46), "frame_square_mac_bate.png", ccui.TextureResType.plistType)
	self.editbox_item:setPosition(cc.p(0, 0))
	self.editbox_item:setFontColor(display.COLOR_BLACK)
	self.editbox_item:setMaxLength(100)
	self.editbox_item:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_SENTENCE)
	self.editbox_item:addTo(self.Node_editbox)
	self.btn_search = SoraDGetChildByName(self, "Button_search")
	self.btn_search:setTitleText("搜一搜")
	self.btn_search:addTouchEventListener(handler(self, self.btnSearchClick))
	SoraDGetChildByName(self, "Text_icon"):setString("道具图标")
	SoraDGetChildByName(self, "Text_name"):setString("道具名字")
	SoraDGetChildByName(self, "Text_id"):setString("道具ID")
	self.Panel_single = SoraDGetChildByName(self, "Panel_single")
	self.Panel_single:setSwallowTouches(false)
end
function cheatItemWindow:initData(style)
	self.style = style
	if style == 1 then
		self.editbox_item:setPlaceHolder("输入道具中文")
		local itemTable = require("app." .. LocalTblPath .. ".config_client.itemdescribe")
		for k, v in pairs(itemTable) do
			table.insert(self.itemIDList, k)
		end
	elseif style == 2 then
		self.editbox_item:setPlaceHolder("输入道具中文")
		local backpack = backpackCtrl:getBackpack(gBackpackDef.PROPS)
		for k, v in pairs(gItemClassifyType) do
			local data = backpack:getClassifyList(v)
			for n, m in pairs(data) do
				table.insert(self.itemIDList, m.id)
				self.itemDataList[m.id] = publicRead.getName(m.id)
			end
		end
	elseif style == 3 then
		self.editbox_item:setVisible(false)
		self.btn_search:setVisible(false)
		_UPVALUE6_ = self.btn_search.setVisible
		self.btn_search.setVisible[1] = BUILDID.STABLES
		self.btn_search.setVisible[2] = BUILDID.RANGE
		self.btn_search.setVisible[3] = BUILDID.CHARIOT_PLANT
		self.btn_search.setVisible[4] = BUILDID.BARRACKS
		self.btn_search.setVisible[5] = BUILDID.FORTRESS
		local self.btn_search.setVisible[6], buildID = BUILDID.ELITE_PALACE, self.btn_search.setVisible
		local armyLogic = include("armyLogic")
		for k, v in pairs(buildID) do
			local soldierList, maxIndex = armyLogic.getCanTrainList(v)
			for n, m in pairs(soldierList) do
				if m.iscantrain then
					table.insert(self.itemIDList, m.armyid)
				end
			end
		end
	end
	self.totalPage = math.ceil(table.nums(self.itemIDList) / self.onceLoad)
	self:initScroll()
end
function cheatItemWindow:initScroll()
	self.scroll:removeAllChildren()
	local index = 1
	local scrollHeight = self.onceLoad * 100
	for i = (self.curPage - 1) * self.onceLoad + 1, self.curPage * self.onceLoad do
		local itemID = self.itemIDList[i]
		if type(itemID) == "number" then
			local itemSingle = self.Panel_single:clone()
			if self.style == 3 then
				local armyDesRead = include("armyDesRead")
				local armyLogic = include("armyLogic")
				local alv = armyLogic.getArmyLV(itemID)
				local wlv = armyDesRead.getWarLv(itemID)
				if math.floor(itemID / 100) == 8 then
					alv = armyLogic.getTrapLV(itemID)
				end
				SoraDGetChildByName(itemSingle, "Text_name"):setString("Lv." .. alv .. armyDesRead.getName(itemID))
				if 0 < wlv then
					SoraDGetChildByName(itemSingle, "Text_name"):setString("战" .. wlv .. " Lv." .. alv .. armyDesRead.getName(itemID))
				end
				SoraDGetChildByName(itemSingle, "Text_ID"):setString(itemID)
				SoraDGetChildByName(itemSingle, "Image_item_bg"):loadTexture("frame_item_base_04.png", ccui.TextureResType.plistType)
				SoraDGetChildByName(itemSingle, "Image_item"):loadTexture(armyDesRead.getIcon(itemID), ccui.TextureResType.plistType)
			else
				SoraDGetChildByName(itemSingle, "Text_name"):setString(publicRead.getName(itemID))
				SoraDGetChildByName(itemSingle, "Text_ID"):setString(itemID)
				SoraDGetChildByName(itemSingle, "Image_item_bg"):loadTexture(publicRead.getBg(itemID), ccui.TextureResType.plistType)
				SoraDGetChildByName(itemSingle, "Image_item"):loadTexture(publicRead.getIcon(itemID), ccui.TextureResType.plistType)
			end
			itemSingle:setPosition(cc.p(0, scrollHeight - 100 * index))
			itemSingle:setTag(itemID)
			itemSingle:addTouchEventListener(handlerEx(self, self.cheatGet, itemID))
			itemSingle:addTo(self.scroll)
			index = index + 1
		end
	end
	self.text_page:setString(self.curPage .. "/" .. self.totalPage)
end
function cheatItemWindow:btnSearchClick(button, touchType)
	if touchType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.style == 2 then
			self.itemIDList, _ENV = self.style, self.style
			local itemText = self.editbox_item:getText()
			for k, v in pairs(self.itemDataList) do
				if string.match(v, itemText) then
					table.insert(self.itemIDList, k)
				end
			end
		elseif self.style == 1 then
			local itemName = self.editbox_item:getText()
			if itemName and string.len(itemName) > 0 then
				local itemDescribe = require("app." .. LocalTblPath .. ".config_client.itemdescribe")
				local zh_cn = require("app." .. LocalTblPath .. ".config_client.local_zh_cn")
				local zh_cn_ext = require("app." .. LocalTblPath .. ".config_client.local_zh_cn_ext")
				self.itemIDList, _ENV = "app." .. LocalTblPath .. ".config_client.local_zh_cn_ext", "app." .. LocalTblPath .. ".config_client.local_zh_cn_ext"
				for k, v in pairs(itemDescribe) do
					if type(k) == "number" and type(v) == "table" then
						if k == tonumber(itemName) then
							table.insert(self.itemIDList, k)
						elseif zh_cn[v.name[1]] then
							local str_cn = zh_cn[v.name[1]]
							if str_cn and string.len(str_cn) > 0 and string.match(str_cn, itemName) then
								table.insert(self.itemIDList, k)
							end
						elseif zh_cn_ext[v.name[1]] then
							local str_cn = zh_cn_ext[v.name[1]]
							if str_cn and string.len(str_cn) > 0 and string.match(str_cn, itemName) then
								table.insert(self.itemIDList, k)
							end
						end
					end
				end
			end
		end
		self.totalPage = math.ceil(table.nums(self.itemIDList) / self.onceLoad)
		if 0 < self.totalPage then
			self.curPage = 1
			self:initScroll()
		else
			SoraDShowMsgTip("抱歉没有搜索到相关物品")
			self.curPage = 0
			self:initScroll()
		end
	end
end
function cheatItemWindow:btnPreClick(button, touchType)
	if touchType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.curPage = self.curPage - 1
		if self.curPage < 1 then
			self.curPage = self.totalPage
		end
		self:initScroll()
	end
end
function cheatItemWindow:btnNextClick(button, touchType)
	if touchType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.curPage = self.curPage + 1
		if self.curPage > self.totalPage then
			self.curPage = 1
		end
		if 1 > self.totalPage then
			self.curPage = 0
		end
		self:initScroll()
	end
end
function cheatItemWindow:cheatGet(itemID, target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local cheatItemGetView = SoraDCreatePanel("cheatItemGetView")
		cheatItemGetView:initData(itemID, self.style)
		cheatItemGetView:show()
	end
end
return cheatItemWindow

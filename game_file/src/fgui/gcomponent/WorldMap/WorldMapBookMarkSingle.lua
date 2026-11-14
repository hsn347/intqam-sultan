local gametop = gModuleMgr.getObject("gametop")
local worldMapDefine = include("worldMapDefine")
local collectMapCtrl = SoraDGetCtrl("collectMapCtrl")
local allianceDesRead = include("allianceDesRead")
local mapResExplainRead = include("mapResExplainRead")
local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local baseComponent = require("fgui.base.baseComponent")
local activity_9001573_Read = include("activity_9001573_Read")
local activity_9001573_Ctrl = SoraDGetCtrl("activity_9001573_Ctrl")
local WorldMapBookMarkSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WorldMap/WorldMapBookMarkSingle", WorldMapBookMarkSingle)
function WorldMapBookMarkSingle:onInit()
	self.tblBookMark, _ENV = nil, nil
	self:fixChildrenPos()
	self.fields.panel:addClickListener(handler(self, self.panelClick))
	self.fields.Button_edit:addClickListener(handler(self, self.btnEditClick))
	self.fields.Button_del:addClickListener(handler(self, self.btnDelClick))
	self.fields.CheckBox_item:addClickListener(handler(self, self.checkBoxClick))
	_UPVALUE3_ = self.fields.CheckBox_item.addClickListener
	self.tableTypeImg, self.fields.CheckBox_item.addClickListener[1] = self.fields.CheckBox_item.addClickListener, "icon_map_favorite_01.png"
	self.tableTypeImg, self.fields.CheckBox_item.addClickListener[2] = self.fields.CheckBox_item.addClickListener, "icon_map_favorite_02.png"
	self.tableTypeImg, self.fields.CheckBox_item.addClickListener[3] = self.fields.CheckBox_item.addClickListener, "icon_map_favorite_03.png"
end
function WorldMapBookMarkSingle:onShow()
end
function WorldMapBookMarkSingle:initData(bookMarkData)
	self.tblBookMark = bookMarkData
	self:initView()
end
function WorldMapBookMarkSingle:initView()
	local nameStr = self.tblBookMark.name
	if worldMapDefine.isInRoaringFlame() and self.tblBookMark.type == gCollectType.alliance then
		local width = self.fields.Text_name:getWidth()
		local fontSize = self.fields.Text_name:getFontSize()
		nameStr = SoraDConvertOmissionText(width, nameStr, fontSize)
	end
	self.fields.Text_name:setString(nameStr)
	if self.isInWar then
		worldMapDefine = nameStr
		nameStr.x = self.tblBookMark.pos.x
		nameStr.y = self.tblBookMark.pos.y
		self.fields.Text_pos:setString(i18n("common_text_465", nameStr))
	elseif worldMapDefine.isLegendLordKingdomID(self.tblBookMark.pos.k) then
		worldMapDefine = i18n("common_text_465", nameStr)
		i18n("common_text_465", nameStr).x = self.tblBookMark.pos.x
		i18n("common_text_465", nameStr).y = self.tblBookMark.pos.y
		self.fields.Text_pos:setString(i18n("common_text_465", i18n("common_text_465", nameStr)))
	else
		worldMapDefine = i18n("common_text_465", i18n("common_text_465", nameStr))
		i18n("common_text_465", i18n("common_text_465", nameStr)).x = self.tblBookMark.pos.x
		i18n("common_text_465", i18n("common_text_465", nameStr)).y = self.tblBookMark.pos.y
		i18n("common_text_465", i18n("common_text_465", nameStr)).k = self.tblBookMark.pos.k
		self.fields.Text_pos:setString(i18n("common_text_639", i18n("common_text_465", i18n("common_text_465", nameStr))))
	end
	self.fields.Image_leftTopBanner:setVisible(not self.tblBookMark.isLook)
	self.fields.CheckBox_item:setSelected(not not self.tblBookMark.isCheck)
	local collectType = self.tblBookMark.type
	if collectType == gCollectType.alliance or collectType == gCollectType.nebulaDefence then
		local markType = self.tblBookMark.markType
		if collectType == gCollectType.alliance then
			self.fields.Sprite_type:setSpriteFrame(mapResExplainRead.getAlliancemapmarkIcon(markType))
		elseif collectType == gCollectType.nebulaDefence then
			self.fields.Sprite_type:setSpriteFrame(activity_9001573_Read.getCampMarkIcon(markType))
		end
		self.fields.Button_edit:setIcon("icon_mail_fenxiang.png")
		self.fields.CheckBox_item:setVisible(false)
	else
		self.fields.Sprite_type:setSpriteFrame(self.tableTypeImg[collectType])
		self.fields.Button_edit:setIcon("icon_bianji.png")
	end
end
function WorldMapBookMarkSingle:initIsInWar(bool)
	self.isInWar = bool
end
function WorldMapBookMarkSingle:panelClick()
	SoraDPlaySound()
	SoraDGotoWorldMapPoint(cc.p(self.tblBookMark.pos.x, self.tblBookMark.pos.y), true, self.tblBookMark.pos.k)
	SoraDRemoveAllPrePanelFromManager(self, true)
end
function WorldMapBookMarkSingle:btnEditClick()
	SoraDPlaySound()
	local collectType = self.tblBookMark.type
	if collectType == gCollectType.alliance or collectType == gCollectType.nebulaDefence then
		collectMapCtrl = gCollectType.nebulaDefence
		local gCollectType.nebulaDefence[1], shareArray = self.tblBookMark.markType, gCollectType.nebulaDefence
		if collectType == gCollectType.alliance then
			collectMapCtrl:reqShareAllianceMark(shareArray)
		elseif collectType == gCollectType.nebulaDefence then
			_ENV = shareArray
			shareArray.key = self.tblBookMark.markType
			activity_9001573_Ctrl:reqShareMark(shareArray)
		end
		return
	end
	self.tblBookMark.isEdit = true
	_ENV = shareArray
	shareArray.markData = self.tblBookMark
	shareArray.title = i18n("common_text_640")
	uiManager:show("WorldMapBookMarkPop", shareArray)
end
function WorldMapBookMarkSingle:btnDelClick()
	SoraDPlaySound()
	local showMsg = i18n("common_text_4327")
	local collectType = self.tblBookMark.type
	if collectType == gCollectType.alliance then
		local worldMapWarDef = include("worldMapWarDef")
		if not worldMapWarDef.checkAllianceMarkRank(true) then
			return
		end
		showMsg = i18n("alliance_mapmark_text_004")
	elseif collectType == gCollectType.nebulaDefence then
		if not activity_9001573_Ctrl:getIsCommander() then
			SoraDShowMsgTip(i18n("Celestial_defense_text_017"))
			return
		end
		showMsg = i18n("alliance_mapmark_text_004")
	end
	SoraDShowMsgBox(showMsg, i18n("common_text_054"), i18n("common_text_185"), function(callType)
		if callType == MSGBOX_CALLBACK_YES and self.tblBookMark then
			local _ENV, delArray = self.tblBookMark, self.tblBookMark
			local collectType = self.tblBookMark.type
			if collectType == gCollectType.alliance then
				table.insert(delArray, self.tblBookMark.markType)
				collectMapCtrl:reqDelAllianceMark(delArray)
			elseif collectType == gCollectType.nebulaDefence then
				_ENV = delArray
				delArray.key = self.tblBookMark.markType
				activity_9001573_Ctrl:reqDelMark(delArray)
			else
				collectMapCtrl, _ENV = self.tblBookMark.markType, delArray
				delArray.position, self.tblBookMark.markType[1] = self.tblBookMark.markType, self.tblBookMark.pos.x
				delArray.position, self.tblBookMark.markType[2] = self.tblBookMark.markType, self.tblBookMark.pos.y
				delArray.mapID = self.tblBookMark.pos.mapID or self.tblBookMark.pos.k
				table.insert(delArray, delArray)
				collectMapCtrl:deleteCollectMap(delArray)
			end
		end
	end)
end
function WorldMapBookMarkSingle:showCheck(bool)
	if self.tblBookMark.type == gCollectType.alliance or self.tblBookMark.type == gCollectType.nebulaDefence then
		return
	end
	self.fields.CheckBox_item:setVisible(bool)
end
function WorldMapBookMarkSingle:checkBoxClick()
	SoraDPlaySound()
end
function WorldMapBookMarkSingle:isItemCheck()
	return self.fields.CheckBox_item:isSelected()
end
return WorldMapBookMarkSingle

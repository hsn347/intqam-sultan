local zh_cn = require("app." .. LocalTblPath .. ".config_client.local_zh_cn")
local en = require("app." .. LocalTblPath .. ".config_client.local_en")
local arab = require("app." .. LocalTblPath .. ".config_client.local_arab")
local cn = require("app." .. LocalTblPath .. ".config_client.local_cn")
local zh_tw = require("app.localtb_en.config_client.local_zh_tw")
local fa = require("app.localtb_en.config_client.local_fa")
local es = require("app.localtb_en.config_client.local_es")
local tr = require("app.localtb_en.config_client.local_tr")
local fr = require("app.localtb_en.config_client.local_fr")
local de = require("app.localtb_en.config_client.local_de")
local pt = require("app.localtb_en.config_client.local_pt")
local it = require("app.localtb_en.config_client.local_it")
local ru = require("app.localtb_en.config_client.local_ru")
local ro = require("app.localtb_en.config_client.local_ro")
local ja = require("app.localtb_en.config_client.local_ja")
local id = require("app.localtb_en.config_client.local_id")
local vi = require("app.localtb_en.config_client.local_vi")
local pl = require("app.localtb_en.config_client.local_pl")
local ko = require("app.localtb_en.config_client.local_ko")
_ENV, _ENV = nil, "app.localtb_en.config_client.local_ko"
_ENV, ("app.localtb_en.config_client.local_ko")[1], (nil).name = nil, nil, "zh_cn(简体中文)"
_ENV, ("app.localtb_en.config_client.local_ko")[2], (nil).name = nil, nil, "en(英文)"
_ENV, ("app.localtb_en.config_client.local_ko")[3], (nil).name = nil, nil, "arab(阿语)"
_ENV, ("app.localtb_en.config_client.local_ko")[4], (nil).name = nil, nil, "cn(简体中文)"
_ENV, ("app.localtb_en.config_client.local_ko")[5], (nil).name = nil, nil, "zh_tw(繁体中文)"
_ENV, ("app.localtb_en.config_client.local_ko")[6], (nil).name = nil, nil, "fa(波斯语)"
_ENV, ("app.localtb_en.config_client.local_ko")[7], (nil).name = nil, nil, "es(西班牙语)"
_ENV, ("app.localtb_en.config_client.local_ko")[8], (nil).name = nil, nil, "tr(土耳其语)"
_ENV, ("app.localtb_en.config_client.local_ko")[9], (nil).name = nil, nil, "fr(法语)"
_ENV, ("app.localtb_en.config_client.local_ko")[10], (nil).name = nil, nil, "de(德语)"
_ENV, ("app.localtb_en.config_client.local_ko")[11], (nil).name = nil, nil, "pt(葡萄牙语)"
_ENV, ("app.localtb_en.config_client.local_ko")[12], (nil).name = nil, nil, "it(意大利语)"
_ENV, ("app.localtb_en.config_client.local_ko")[13], (nil).name = nil, nil, "ru(俄语)"
_ENV, ("app.localtb_en.config_client.local_ko")[14], (nil).name = nil, nil, "ro(罗马尼亚语)"
_ENV, ("app.localtb_en.config_client.local_ko")[15], (nil).name = nil, nil, "ja(日语)"
_ENV, ("app.localtb_en.config_client.local_ko")[16], (nil).name = nil, nil, "id(印尼语)"
_ENV, ("app.localtb_en.config_client.local_ko")[17], (nil).name = nil, nil, "vi(越南语)"
_ENV, ("app.localtb_en.config_client.local_ko")[18], (nil).name = nil, nil, "pl(波兰语)"
;("app.localtb_en.config_client.local_ko")[19], (nil).name = nil, "ko(韩语)"
local tableInfo = "app.localtb_en.config_client.local_ko"
local checkMultiLanguageView = class("checkMultiLanguageView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("checkMultiLanguageView")
	end
	return target
end)
function checkMultiLanguageView:ctor()
	self:initControls()
	self:initData()
end
function checkMultiLanguageView:initControls()
	self.panel = SoraDGetChildByName(self, "Panel_cut")
	self.Node_editbox = SoraDGetChildByName(self, "Node_editbox")
	self.txtTable = SoraDGetChildByName(self, "Text_table")
	self.txtLanguage = SoraDGetChildByName(self, "Text_languange")
	self.nodeSingle = SoraDGetChildByName(self, "node_display")
	self.scroll = SoraDGetChildByName(self, "ScrollView_2")
	self.editbox_item = ccui.EditBox:create(cc.size(320, 46), "frame_square_mac_bate.png", ccui.TextureResType.plistType)
	self.editbox_item:setPosition(cc.p(0, 0))
	self.editbox_item:setFontColor(display.COLOR_BLACK)
	self.editbox_item:setMaxLength(100)
	self.editbox_item:setPlaceHolder("输入多语言的key, 谢谢")
	self.editbox_item:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_SENTENCE)
	self.editbox_item:addTo(self.Node_editbox)
	self.txtTable:setString("多语言表名")
	self.txtLanguage:setString("翻译在下面呢")
	self.btn_search = SoraDGetChildByName(self, "Button_search")
	self.btn_search:setTitleText("搜一搜")
	self.btn_search:addTouchEventListener(handler(self, self.btnSearchClick))
	self.panel:setPositionY(display.height / 2)
end
function checkMultiLanguageView:initData()
	self.languageList, _ENV = nil, nil
	table.insert(self.languageList, zh_cn)
	table.insert(self.languageList, en)
	table.insert(self.languageList, arab)
	table.insert(self.languageList, cn)
	table.insert(self.languageList, zh_tw)
	table.insert(self.languageList, fa)
	table.insert(self.languageList, es)
	table.insert(self.languageList, tr)
	table.insert(self.languageList, fr)
	table.insert(self.languageList, de)
	table.insert(self.languageList, pt)
	table.insert(self.languageList, it)
	table.insert(self.languageList, ru)
	table.insert(self.languageList, ro)
	table.insert(self.languageList, ja)
	table.insert(self.languageList, id)
	table.insert(self.languageList, vi)
	table.insert(self.languageList, pl)
	table.insert(self.languageList, nl)
	table.insert(self.languageList, ko)
end
function checkMultiLanguageView:initScroll()
	self.scroll:removeAllChildren()
	local scrollH = math.max(#self.languageList * 80, self.scroll:getContentSize().height)
	self.scroll:setInnerContainerSize(cc.size(self.scroll:getContentSize().width, scrollH))
	local itemName = self.editbox_item:getText()
	for i, v in ipairs(self.languageList) do
		local single = self.nodeSingle:clone()
		single:setPosition(cc.p(self.scroll:getContentSize().width / 2, scrollH - (i - 1) * 80))
		single:addTo(self.scroll)
		local txtTableName = SoraDGetChildByName(single, "text_tableName")
		txtTableName:setString(tableInfo[i].name .. "：")
		local txtTranslante = SoraDGetChildByName(single, "text_translante")
		txtTranslante:setString(itemName)
		if v[itemName] then
			txtTranslante:setString(v[itemName])
		end
		txtTranslante:setPositionX(txtTableName:getPositionX() + txtTableName:getContentSize().width + 10)
	end
end
function checkMultiLanguageView:btnSearchClick(button, touchType)
	if touchType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:initScroll()
	end
end
return checkMultiLanguageView

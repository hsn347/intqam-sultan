local publicRead = include("publicRead")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_bottomBatch = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/Com_bottomBatch", Com_bottomBatch)
function Com_bottomBatch:onInit()
	self.itemSID = 513201
	self.itemSSID = 513101
	self.fields.Text_title:setString(i18n("Hero_reshape_17"))
	self.fields.Button_batch:setString(i18n("Hero_reshape_16"))
	self.fields.Button_batch:addClickListener(handler(self, self.btnBatchClick))
	self.fields.Button_cancel:setString(i18n("common_text_185"))
	self.fields.Button_cancel:addClickListener(handler(self, self.btnCancelClick))
	self.fields.Lab_SS:fixChildrenPos()
	self.fields.Lab_SS:fixPos()
	self.fields.Button_batch:fixPos()
	self.fields.Button_cancel:fixPos()
end
function Com_bottomBatch:onShow()
	self.fields.Lab_SS:setIcon(publicRead.getIcon(self.itemSSID))
end
function Com_bottomBatch:initData(parent, chipList)
	self.parent = parent
	self.chipList = chipList
	local sNum = 0
	local ssNum = 0
	for k, v in ipairs(self.chipList) do
		if v.isSelect then
			local exchangeCfg = heroltCtrl:getExchangeInfo(v.id)
			if exchangeCfg.newTokenID == self.itemSID then
				sNum = sNum + exchangeCfg.newTokenNum * v.count
			end
			if exchangeCfg.newTokenID == self.itemSSID then
				ssNum = ssNum + exchangeCfg.newTokenNum * v.count
			end
		end
	end
	self.fields.Lab_SS:setTitle(ssNum)
	self.fields.Button_batch:setEnabled(0 < sNum + ssNum)
end
function Com_bottomBatch:btnBatchClick()
	SoraDPlaySound()
	SoraDCheckSecondaryLock(function()
		_ENV = nil
		;(nil).content = i18n("Hero_reshape_18")
		;(nil).confirmString = i18n("common_text_204")
		;(nil).confirmFunc = function()
			local _ENV, exchangeInfo
			for k, v in ipairs(self.chipList) do
				if v.isSelect then
					local exchangeCfg = heroltCtrl:getExchangeInfo(v.id)
					_ENV = nil
					;(nil).exchangeId = exchangeCfg.index
					;(nil).count = v.count
					table.insert(exchangeInfo, nil)
				end
			end
			heroCtrl:exchangeBatch(exchangeInfo)
			self.parent:cancel()
		end
		;(nil).cancelString = i18n("common_text_185")
		uiManager:show("MessageBox", nil)
	end, gSecondaryLockType.HeroChipExchange, "HeroExchangeShop")
end
function Com_bottomBatch:btnCancelClick()
	SoraDPlaySound()
	self.parent:cancel()
end
return Com_bottomBatch

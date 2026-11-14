local publicRead = include("publicRead")
local equipDesRead = include("equipDesRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_list2 = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://RechargeView/Com_list2", Com_list2)
function Com_list2:onInit()
	self.fields.item:setClickCallback(handler(self, self.onItemClick))
	self:fixChildrenPos()
	self.fields.n31:fix()
	self.fields.n32:fix()
	self.fields.Particle_1:setRotation(SoraDFIsRA() and -90 or 90)
end
function Com_list2:onShow()
end
function Com_list2:initData(data, index)
	self.data = data
	self.fields.nbg:setVisible(index % 2 == 1)
	if data.type and data.type == "buff" then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.item:forbidLongPress()
		self.fields.item:hideQuality()
		self.fields.item:setIcon(data.buff.icon)
		self.fields.item:setSpecialNum()
		self.fields.item:setNumText()
		self.fields.Text_itemName:setString(data.buff.name)
		self.fields.Text_itemCount:setVisible(false)
		self.controllers.c2:setSelectedIndex(0)
	else
		local itemID = tonumber(data.id)
		if 40000091 <= itemID and itemID <= 40003102 then
			itemID = equipDesRead.getEquipQualityCfgID(itemID)
		end
		local ret, remainTime, foreverCount, curCount = backpackCtrl:getOwnDressInfo(itemID)
		print("ret=======", itemID, ret, remainTime, foreverCount, curCount)
		self.controllers.c2:setSelectedIndex(ret == true and 1 or 0)
		if ret then
			if 0 < remainTime then
				self.fields.Text_tip:setTimeLast(function(time)
					_ENV = nil
					;(nil).time = time
					return i18n("common_text_4936", nil)
				end)
				self.fields.Text_tip:setTimeEndListener(function()
					self = nil
					;(nil).num = string.formatnumberthousands(curCount)
					self.fields.Text_tip:setString(i18n("skin_text_23", nil))
					self.fields.Text_tip:setColor("#E02B2B")
				end)
				self.fields.Text_tip:beginTime(remainTime)
				self.fields.Text_tip:setColor("#70C723")
			else
				self.fields.Text_tip:setString(i18n("common_text_4831"))
				self.fields.Text_tip:setColor("#E02B2B")
			end
		elseif ret == false then
			if 0 < foreverCount then
				self.fields.Text_tip:setString(i18n("common_text_4937"))
				self.fields.Text_tip:setColor("#70C723")
			else
				_ENV = i18n("common_text_4937")
				i18n("common_text_4937").num = string.formatnumberthousands(curCount)
				self.fields.Text_tip:setString(i18n("skin_text_23", i18n("common_text_4937")))
				self.fields.Text_tip:setColor("#E02B2B")
			end
		end
		self.fields.item:openLongPress()
		self.fields.item:initData(itemID)
		self.fields.Text_itemName:setString(publicRead.getName(itemID))
		self.fields.Text_itemName:setColor(publicRead.checkLevelCondition(itemID) and cc.c3b(190, 40, 40) or cc.c3b(205, 190, 148))
		self.fields.Text_itemName2:setString(publicRead.getName(itemID))
		self.fields.Text_itemName2:setColor(publicRead.checkLevelCondition(itemID) and cc.c3b(190, 40, 40) or cc.c3b(205, 190, 148))
		self.fields.Text_itemCount:setString("x" .. data.count)
		self.fields.Text_itemCount:setVisible(true)
		self.controllers.c1:setSelectedIndex(data.isHighLight and 1 or 0)
		if data.quality then
			self.fields.item:setQualityIcon(publicRead.getBgByQuality(data.quality))
		end
	end
end
function Com_list2:onItemClick()
	if self.data.type and self.data.type == "buff" then
		local panel = SoraDCreatePanel("princeGiftNewBuffPreviewPopView")
		panel:initData(self.data.buff.desc)
		panel:show()
	end
end
return Com_list2

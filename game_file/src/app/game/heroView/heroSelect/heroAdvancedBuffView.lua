local gametop = gModuleMgr.getObject("gametop")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local buffDesRead = include("buffDesRead")
local heroAdvancedBuffView = class("heroAdvancedBuffView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("heroAdvancedBuffView")
	end
	return target
end)
function heroAdvancedBuffView:ctor()
	self.attrArray, _ENV = nil, nil
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("share_text_03"))
	self.Text_None = SoraDGetChildByName(self, "Text_None")
	self.Text_None:setString(i18n("share_text_04"))
	self.Text_None:setVisible(false)
	self.scroll = SoraDGetChildByName(self, "ScrollView_list")
	self.Node_single = SoraDGetChildByName(self, "Node_single")
end
function heroAdvancedBuffView:initData(data)
	if data == nil then
		return
	end
	self.Text_None:setVisible(#data == 0)
	self.scroll:setVisible(0 < #data)
	if 0 < #data then
		table.sort(data, function(a, b)
			if a.showIndex == b.showIndex then
				return a.key < b.key
			else
				return a.showIndex < b.showIndex
			end
		end)
		local scrollH = math.max(340, #data * 36)
		self.scroll:setInnerContainerSize(cc.size(516, scrollH))
		for k, v in ipairs(data) do
			local single
			if k == 1 then
				single = self.Node_single
			else
				single = self.Node_single:clone()
				single:addTo(self.scroll)
			end
			single:setPosition(258, scrollH - 36 * k)
			SoraDGetChildByName(single, "Image_light"):setVisible(k % 2 == 0)
			SoraDGetChildByName(single, "Text_name"):setString(buffDesRead.getTitleBase(v.key, false, true))
			SoraDGetChildByName(single, "Text_val"):setString(buffDesRead.getTitleValueWithValue(v.key, v.val))
		end
	end
end
return heroAdvancedBuffView

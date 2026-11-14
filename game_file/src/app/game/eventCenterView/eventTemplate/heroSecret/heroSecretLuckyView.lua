local heroSecretltCtrl = include("heroSecretltCtrl")
local publicRead = include("publicRead")
local heroSecretLuckyView = class("heroSecretLuckyView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("heroSecretLuckyView")
	end
	return target
end)
function heroSecretLuckyView:ctor()
	self.singleArray, _ENV = nil, nil
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("herovault_text_12"))
	self.Text_des = SoraDGetChildByName(self, "Text_des")
	self.Text_des:setString(i18n("herovault_text_09"))
	self.Node_title = SoraDGetChildByName(self, "Node_title")
	self.Text_lucky = SoraDGetChildByName(self, "Text_lucky")
	self.Text_lucky:setString(i18n("herovault_text_12"))
	self.Text_reward = SoraDGetChildByName(self, "Text_reward")
	self.Text_reward:setString(i18n("common_text_2078"))
	self.Image_line = SoraDGetChildByName(self, "Image_line")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_info")
	self.Node_single = SoraDGetChildByName(self, "Node_single")
	self.cfg = heroSecretltCtrl.getLuckyCfg()
	self:suitView()
	self:initData()
end
function heroSecretLuckyView:suitView()
	local desHeight = SoraDGetAutoHeightLabel(self.Text_des, 520)
	self.Node_title:setPositionY(self.Text_des:getPositionY() - desHeight - 50)
	self.scroll:setPositionY(self.Node_title:getPositionY())
	self.scroll:setContentSize(cc.size(536, #self.cfg * 34))
end
function heroSecretLuckyView:initData()
	local cfg = heroSecretltCtrl.getLuckyCfg()
	local scrollH = #self.cfg * 34
	self.scroll:setInnerContainerSize(cc.size(536, scrollH))
	self.scroll:setBounceEnabled(false)
	self.Image_line:setContentSize(cc.size(2, 34 + #self.cfg * 34))
	for k, v in ipairs(self.cfg) do
		local single
		if k == 1 then
			single = self.Node_single
		else
			single = self.Node_single:clone()
			single:addTo(self.scroll)
		end
		self.singleArray[k] = single
		self.singleArray[k]:setPosition(268, scrollH - 34 * k)
		local Image_sheer = SoraDGetChildByName(self.singleArray[k], "Image_sheer")
		Image_sheer:setVisible(k % 2 == 0)
		local Text_point = SoraDGetChildByName(self.singleArray[k], "Text_point")
		if k < #self.cfg then
			Text_point:setString(string.format("%d-%d", v.luckyPointGear[1], v.luckyPointGear[2]))
		else
			Text_point:setString(string.format("%d+", v.luckyPointGear[1]))
		end
		local Text_item = SoraDGetChildByName(self.singleArray[k], "Text_item")
		publicRead = string.format("%d+", v.luckyPointGear[1])
		string.format("%d+", v.luckyPointGear[1])[1] = "id"
		string.format("%d+", v.luckyPointGear[1])[2] = "count"
		local itemList = serviceFunctions.tableFormat(v.gearReward, string.format("%d+", v.luckyPointGear[1]))
		local str = ""
		for ki, vi in ipairs(itemList) do
			if ki == #itemList then
				str = str .. string.format("%s*%d", publicRead.getName(vi.id), vi.count)
			else
				str = str .. string.format("%s*%d,", publicRead.getName(vi.id), vi.count)
			end
		end
		Text_item:setString(str)
	end
end
return heroSecretLuckyView

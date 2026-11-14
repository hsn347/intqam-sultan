local activity_9001661_Ctrl = SoraDGetCtrl("activity_9001661_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_recordSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001661/Com_recordSingle", Com_recordSingle)
function Com_recordSingle:onInit()
	self.fields.Image_new:setSpriteFrame(SoraDFIsRA() and "img_common_new_ar.png" or "img_common_new_en.png")
	self.fields.Text_content:addClickListener(handler(self, self.btnClick))
	self:fixChildrenPos()
end
function Com_recordSingle:onShow()
end
function Com_recordSingle:initData(data, tag)
	self.data = data
	self.tag = tag
	self.controllers.c_new:setSelectedIndex(0)
	if self.tag == 1 then
		local content = activity_9001661_Ctrl:getOneRecordStr(self.data)
		self.fields.Text_content:setString(content)
		self.fields.Text_time:setString(os.date("!%m-%d %H:%M:%S", self.data.time))
		self.readTime = activity_9001661_Ctrl:getRecordReadTime()
		if not self.readTime or self.data.time > self.readTime then
			self.controllers.c_new:setSelectedIndex(1)
		end
	elseif self.tag == 2 then
		local content = activity_9001661_Ctrl:getOneGrouthStr(self.data)
		self.fields.Text_content:setString(content)
		self.fields.Text_time:setString(os.date("!%m-%d %H:%M:%S", self.data.time))
	end
end
function Com_recordSingle:btnClick()
	if self.tag == 1 then
		SoraDPlaySound()
		activity_9001661_Ctrl:reqBubbleGrangeMembers(self.data.uid)
	end
end
return Com_recordSingle

local baseComponent = require("fgui.base.baseComponent")
local Pet_Step_Icons = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://PetFguiView/Pet_Step_Icons", Pet_Step_Icons)
function Pet_Step_Icons:onInit()
	for index = 1, 4 do
		self.fields["icon_step_" .. index]:addClickListener(handlerEx(self, self.btnClick, index))
	end
end
function Pet_Step_Icons:onShow()
end
function Pet_Step_Icons:setPetData(pet, rank)
	self.curPet = pet
	self.maxRank = #pet.rankInfo
	for index = 1, 4 do
		local icon_step = self.fields["icon_step_" .. index]
		icon_step:setVisible(index <= self.maxRank)
		if rank == index then
			icon_step:setColor(cc.c3b(255, 255, 255))
		else
			icon_step:setColor(cc.c3b(125, 125, 125))
		end
	end
	for index = 1, 3 do
		self.fields["arrow_" .. index]:setVisible(index <= self.maxRank - 1)
		self.fields["arrow_" .. index]:setGrayed(index ~= rank)
	end
end
function Pet_Step_Icons:setBtnPetData(data)
	self:setPetData(data.pet, data.rank)
	if data.pet_model then
		self.pet_model = data.pet_model
	end
	if self.pet_model then
		_UPVALUE0_ = data.pet
		data.pet.pid = self.curPet.pid
		data.pet.rank = data.rank
		self.pet_model:initData(data.pet)
		self.pet_model:setScale(0.8)
	end
end
function Pet_Step_Icons:btnClick(index, EventContext)
	_UPVALUE0_ = nil
	;(nil).pet = self.curPet
	;(nil).rank = index
	self:setBtnPetData(nil)
end
return Pet_Step_Icons

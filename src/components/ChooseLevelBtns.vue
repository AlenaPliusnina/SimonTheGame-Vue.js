<template>
	<div class="select-level-wrap">
        <label v-for="button in buttons" :disabled="disabled"
            v-on:click="updateInputData(button.key)"
            :key="button.key" :for="button.key" 
            :class="{ label: true, label_disabled: disabled,}">
                {{ button.value }}
            <input class="button" type="radio"
                :disabled="disabled"
                :name="name" 
                :value="button.key"
                :id="button.key"
                :checked="button.key === value"
                v-on:change="updateInputData($event.target.value)"/>
        </label>
	</div>
</template>

<script>
export default {
	name: 'ChooseLevelBtns',
	props: {
		disabled: Boolean,
		name: {
			type: String,
			required: true
		},
		defaultValue: {
			type: String,
			default: ''
		},
		buttons: {
			type: Array,
			required: true
		},
	},
	data() {
		return {
			value: this.defaultValue
		}
	},
	methods: {
		updateInputData(value) {
			this.value = value;
			this.$emit('update-input-data', value);
		}
	}
}
</script>

<style lang="sass" scoped>
.select-level-wrap 
    .label 
        cursor: pointer
        display: flex
        align-items: center
        font-size: 14px
        color: $primary_color
        margin-bottom: 4px
        margin-right: 10px
        font-size: 1rem

        &:hover
            color: green
        
        &:focus
            color: green               
        
        .button
            cursor: inherit
            -webkit-appearance: unset
            margin-right: 5px 
            display: block
            position: relative
            height: 20px
            width: 20px
            outline: none
            order: -1

            &:focus
                color: green

            &::before 
                cursor: inherit
                content: ''
                display: inherit
                margin-right: 10px
                width: 18px
                height: 18px
                border: 1px solid black
                border-radius: 10px
                background-color: white
            
            &:checked::before 
                border-color: $primary_color
            
            &:checked::after
                content: ''
                display: inherit
                position: absolute
                cursor: inherit
                width: 12px
                height: 12px
                background: $primary_color
                border-radius: 50%
                top: calc(50% - 6px)
                right: calc(50% - 6px)
                background-color: green

        &_disabled 
            opacity: 0.6
            cursor: default
            
</style>
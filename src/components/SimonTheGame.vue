<template>
	<div class="game-wrapper">
		<h1 class="game-name">Simon The Game</h1>
		<div class="simon-buttons" :class="{'hilight': isHighlighting}">
			<div v-for="button in buttons" :key="button.id" 
				:class="{[button.class]: true, 'button_highlight': button.isHighlighted }" 
				v-on:click="buttonClick(button.id)"> 
			</div>
		</div>
		<div class="game-controls">
			<p v-show="isGameOn" class="round">
				{{ round }}: {{ roundNumber }}
			</p>
			<p v-show="isUserFail" class="losing-message">
				{{ lossMessage }}: {{ roundNumber }}
			</p>
			<div>
				<div v-on:click="startTheGame">
					<button v-if="!isGameOn" class="start-button">
						{{ startBtn }}
					</button>
				</div>
				<h3>Уровень</h3>
				<div class="choose-level-btns">
					<ChooseLevelBtns 
					:disabled="isHighlighting" 
					:name="levelButtons.name" 
					:buttons="levelButtons.buttons" 
					:defaultValue="levelButtons.value" 
					@update-input-data="setLevel"/>
				</div>
			</div>
		</div>
  </div>
</template>

<script>
import ChooseLevelBtns from '@components/ChooseLevelBtns'

export default {
	name: 'SimonTheGame',
	components: {
		ChooseLevelBtns
	},
	data() {
		return {
			round: 'Раунд',
			startBtn: 'Начать игру',
			lossMessage: 'Вы проиграли в раунде',
			levels: {
				easy: 'легкий',
				medium: 'средний',
				hard: 'сложный'
			},
			buttons: [
				{
					id: 0,
					class: 'button button_first',
					isHighlighted: false
				},
				{
					id: 1,
					class: 'button button_second',
					isHighlighted: false
				},
				{
					id: 2,
					class: 'button button_third',
					isHighlighted: false
				},
				{
					id: 3,
					class: 'button button_fourth',
					isHighlighted: false
				},
			],
			roundNumber: 0,
			level: 'easy',
			isGameOn: false,
			isUserFail: false,
			isHighlighting: false,
			sounds:  [
				"https://s3.amazonaws.com/freecodecamp/simonSound1.mp3",
				"https://s3.amazonaws.com/freecodecamp/simonSound2.mp3",
				"https://s3.amazonaws.com/freecodecamp/simonSound3.mp3",
				"https://s3.amazonaws.com/freecodecamp/simonSound4.mp3",
			],
			userSelect: []
		}
	},
	computed: {
		levelButtons() {
			return {
				name: 'level',
				value: 'easy',
				buttons: Object.entries(this.levels).map(level => {
					const [ key, value ] = level
					return ({
						key: key,
						value: value
					})
				})
			}
		},
		timeout() {
			switch(this.level) {
				case 'easy': return 1.5;
				case 'medium': return 1;
				case 'hard': return 0.4;
				default: return 1.5;
			}
		},
		randomSequence() {
			const data = [];
			for (let i = 0; i < this.roundNumber; i++) {
				data.push(this.getRandomNumber());
			}
			return data;
		},
	},
	methods: {
		setLevel(value) {
			this.clearUserSelect();
			this.level = value;
			if (this.isGameOn && !this.isHighlighting) {
				this.reproduceSequence();
			} 
		},
		startTheGame() {
			this.clearUserSelect();
			this.gameOn(true);
			this.roundNumber = 1;
			this.isUserFail = false;
			this.reproduceSequence();
		},
		clearUserSelect() {
			this.userSelect.length = 0;
		},
		gameOn(value) {
			this.isGameOn = value;
		},
		reproduceSequence() {
			this.isHighlighting = true;
			this.randomSequence.forEach((number, index) => {
				setTimeout(() => {
					this.highlightButton(number);
				}, this.timeout * 1000 * (index + 1));
			});
			setTimeout(() => {
				this.isHighlighting = false;
			}, this.timeout * 1000 * (this.randomSequence.length + 0.8));
		},
		highlightButton(value) {
			this.buttons.forEach(button => {
				if (button.id === value) {
					this.buttons[button.id].isHighlighted = true;
					this.playSound(button.id);
					setTimeout(() => {
						this.buttons[button.id].isHighlighted = false;
					}, this.timeout / 2 * 1000);
				} else this.buttons[button.id].isHighlighted = false;
			})
		},
		playSound(index) {
			const sound = new Audio(this.sounds[index]);
			sound.play();
		},
		getRandomNumber() {
			return Math.floor(Math.random() * Math.floor(4));
		},
		buttonClick(btnId) {
			if (this.isHighlighting) return;
			
			this.playSound(btnId);
			
			if(!this.isGameOn) return;

			this.setUserSelectedButtons(btnId);
			this.setIsUserFail(btnId);

			if (!this.isUserFail && this.randomSequence.length === this.userSelect.length) {
				this.startNextRound();
			}
		},
		setUserSelectedButtons(value) {
			this.userSelect.push(value);
		},
		setIsUserFail(userSelectBtnId) {
			if (this.randomSequence[this.userSelect.length - 1] !== userSelectBtnId) {
				this.userFail();
			}
		},
		userFail() {
			this.isUserFail = true;
			this.gameOn(false);
		},
		startNextRound() {
			this.clearUserSelect();
			this.roundNumber++;
			this.reproduceSequence();
		},
	}
}
</script>

<style lang="sass">
.game-wrapper 
    max-width: 300px
    margin: auto
    display: flex
    flex-wrap: wrap
    justify-content: center
    align-items: center


.game-controls
    display: flex
    flex-wrap: wrap
    justify-content: center

    div
        width: 350px
        display: flex
        flex-wrap: wrap
        justify-content: center


.start-button
    cursor: pointer
    border: 2px solid black
    border-radius: 5px
    font-size: 1rem
    padding: 10px

    &:hover
        background-color: #E1E1E1

.round
    color: green
    margin-bottom: 0
    font-size: 1.3rem

.losing-message
    margin-top: 10px
    color: #9A0404
    font-size: 1.3rem

.simon-buttons 
    min-width: 300px
    max-width: 300px
    max-height: 300px
    min-height: 300px
    margin-top: 20px
    margin-bottom: 20px
    border: 10px solid black
    border-radius: 50%
    position: relative
    cursor: pointer
		
.button 
    transition: 0.25s
    position: absolute
    border-radius: inherit
    width: 100%
    height: 100%
    opacity: 1
          
    &_first 
        clip-path: polygon(50% 0%, 50% 50%, 0 50%, 0 0)
        background-color: $first_button_color
    
    &_second 
        clip-path: polygon(100% 0%, 100% 50%, 50% 50%, 50% 0%)
        background-color: $second_button_color
    
    &_third 
        clip-path: polygon(50% 50%, 50% 100%, 100% 100%, 100% 50%)
        background-color: $third_button_color
    
    &_fourth 
        clip-path: polygon(0 50%, 0 100%, 50% 100%, 50% 50%)
        background-color: $fourth_button_color
    
    &_highlight
        opacity: 0.5
  
    &:hover 
        opacity: 0.5
		
			
.hilight
    .button 
        cursor: default
        &:hover 
            opacity: 1
	
</style>>

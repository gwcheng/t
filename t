Vue.component('v-select', VueSelect.VueSelect);
axios.defaults.timeout = 60000;


access = sessionStorage.getItem('access');
user_id = sessionStorage.getItem('user_id');
me = sessionStorage.getItem('nickname');
dept = sessionStorage.getItem('dept');
console.log("me:"+me);
console.log("access:"+access);
if(access=="" || access== 'undefined'||access==null ){
	$('#app_login')[0].style.display ="block";
}else{
	$('#app_login')[0].style.display ="none";
}

var config = {
  headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
  responseType: 'json'
};
const load_data = new Vue({
	methods: {
		async main(){
			this.load_selector();
		},
		async load_selector() {
			var current_url = window.location.href;
	        	console.log('current_url:'+current_url);
	        	var regexp = /\?([\w]+)/;
	        	var result = current_url.match(regexp);
	        	var re = new RegExp(regexp);
	        	if (re.test(current_url)) {
	        		rd_data_id =result[1];
	        		console.log('rd_data_id:['+rd_data_id+"]");
	        	}
	        	
	        	var data = {
	        		level:0
			};
			axios.post("/rd_data/api/get_manager.php",data,config)
			.then(function (response) {
				//alert(response);
				console.log(response);
				var data = response.data;
				console.log(data);
				rd_data.managers = data.managers;
				if(data.status == "OK"){
					for(var i in data.managers) {
			    			console.log("data.managers:"+data.managers[i].name);
			    		}
				}
				//rd_data.data = response.data;
				//rd_data.answer_list = response.data.ans_list_ary;
			})
			.catch(function (error) {
				
				console.log('Error', error.message);
				console.log(error.config);
				alert('發生錯誤:'+error.message);
			});
			
			var data = {};
			axios.post("/rd_data/api/get_viewer.php",data,config)
			.then(function (response) {
				//alert(response);
				console.log(response);
				var data = response.data;
				console.log(data);
				rd_data.viewers = data.data;
				if(data.status == "OK"){
					
				}
				//rd_data.data = response.data;
				//rd_data.answer_list = response.data.ans_list_ary;
			})
			.catch(function (error) {
				
				console.log('Error', error.message);
				console.log(error.config);
				alert('發生錯誤:'+error.message);
			});
			
			
			var data = {
	        	
			};
			axios.post("/rd_data/api/get_description_type.php",data,config)
			.then(function (response) {
				//alert(response);
				console.log(response);
				var data = response.data;
				
				
				rd_data.description_types = data.data;
				console.log(rd_data.description_types);
				//if(data.status == "OK"){
				//	for(var i in data.managers) {
			    //			console.log("data.managers:"+data.managers[i].name);
			    //		}
				//}
				//rd_data.data = response.data;
				//rd_data.answer_list = response.data.ans_list_ary;
			})
			.catch(function (error) {
				
				console.log('Error', error.message);
				console.log(error.config);
				alert('發生錯誤:'+error.message);
			});
			var date  = new Date();
			var newDate = new Date(date.setMonth(date.getMonth()+1));
			console.log(newDate);
			rd_data.deadline = newDate;
	        	rd_data.user = sessionStorage.getItem('nickname');
			rd_data.dept = sessionStorage.getItem('dept');
	        	await $.unblockUI();
		}
    }
})

const rd_data = new Vue({
    el: '#rd_data',
    data: {
    	id: "",
    	dept: "",
    	user: "",
    	manager:"",
    	managers: [],
    	project_code: "",
    	file_desc: "",
    	viewer:"",
    	viewer_list: [],
    	file: "",
    },
    watch: {
	id: function (newVal) {
		if(this.id !== ""){
			this.btn_type = "UPDATE";
		}
	}
    },
    methods: {
    	logout(event){
    		formData.append('file', this.file);
    		sessionStorage.setItem('access', '');
		sessionStorage.setItem("user_id", "");
		sessionStorage.setItem("nickname", "");
		sessionStorage.setItem("dept", "");
		alert("已登出");
		location.href='rd_request_layout.php';
    	},
    	remove_file(event, index){
    		console.log("remove:"+index)
    		this.file_list.splice(index, 1); 
    	},
    	files_change(event){
    		console.log("fieldName:"+event.target.files[0]);
    		this.file = event.target.files[0];
    		console.log(this.file);
    	},
    	submit_request(event){
    		if(this.file_desc == ""){
    			alert("請填寫檔案需求描述");
    			return;
    		}
    		
    		if(this.file == ""){
    			alert("請上傳檔案");
    			return;
    		}
    		
  	
    		const formData = new FormData();
    		formData.append('dept', this.dept);
    		formData.append('user', this.user);
    		formData.append('user_account', access);
    		formData.append('project_code', this.project_code);
    		formData.append('file_desc', this.file_desc);
    		formData.append('manager', this.manager);
    		
    		//formData.append(this.upload_field_name, upload_files);
    		formData.append("file", this.file);
    		

		console.log(formData);

		 const upload_config = { headers: { 'Content-Type': 'multipart/form-data' } };
		axios.post('/rd_data/api/file_upload_request.php', formData, upload_config)
		.then(function (response) {
			console.log(response);
			console.log(response.data);
			alert("新增完成");
			location.href='file_upload_request.php';
		})
		.catch(function (error) {
			alert('發生錯誤:'+error.message);
		});
		
    	}
    }
})
	
const app_login = new Vue({
  el: '#app_login',
  data: {
    showModal: true,
    account:"",
    password:"",
    warning_msg:""
  },
  methods: {
  	getCookie(name) {
	  var value = "; " + document.cookie;
	  var parts = value.split("; " + name + "=");
	  if (parts.length == 2) return parts.pop().split(";").shift();
	},
	login(event){
		console.log("login");
		
		var data = {
			account:this.account,
			password:this.password,
		};
		console.log(data);
		axios.post("/rd_data/api/login.php",data,config)
		.then(function (response) {
			
			console.log(response);
			var data = response.data;
			var status = data.status;
			
			console.log("status:"+status);
			if(status !== "OK"){
				sessionStorage.setItem('access', '');
				sessionStorage.setItem("user_id", "");
				sessionStorage.setItem("nickname", "");
				sessionStorage.setItem("dept", "");
				alert('發生錯誤:'+response.data.message);
			}else{
				sessionStorage.setItem('access', data.account);
				sessionStorage.setItem("user_id", data.id);
				sessionStorage.setItem("nickname", data.nickname);
				sessionStorage.setItem("dept", data.dept);
				alert('已登入成功');
			}
			location.reload();
		})
		.catch(function (error) {
			alert('發生錯誤:'+error.message);
		});
	},
  }
})
	

load_data.main();

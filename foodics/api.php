<?php
    
	/* 
		This is an example class script proceeding secured API
		Class will execute the function dynamically;
		
		usage :
		
		    $object->response(output_data, status_code);
			$object->_request	- to get santinized input 	
			
			output_data : JSON (I am using)
			status_code : Send status message for headers
 	*/
	require_once("Rest.inc.php");
    define('AREA', 'D');
    use Tygh\Registry;
	class API extends REST {
        const AREA = "D";   
		public $data = "";
		
        const DB_SERVER = "localhost";
        const DB_USER = "root";
        const DB_PASSWORD = "";
        const DB = "foodics";
		
		private $db = NULL;
        private $auth = NULL;
	
		public function __construct(){
            $this->autharization();
			parent::__construct();				// Init parent contructor
			$this->dbConnect();					// Initiate Database connection
		}
		
		/*
         *  basic auth 
        */
        private function autharization(){
                $realm = "Restricted area";
                if (!isset($_SERVER['PHP_AUTH_USER'])) {
                    header('WWW-Authenticate: Basic realm="My Realm"');
                    header('HTTP/1.0 401 Unauthorized');
                    exit;
                } else {
                    if($this->login()){
                        return true;
                    }else{
                        header('WWW-Authenticate: Basic realm="My Realm"');
                        header('HTTP/1.0 401 Unauthorized');
                        exit;
                    } 
                   
                }
        }

        /*
         *  Database connection 
        */
		private function dbConnect(){
			$this->db = new mysqli(self::DB_SERVER,self::DB_USER,self::DB_PASSWORD,self::DB);
		}
		
		/*
		 * Public method for access api.
		 * This method dynmically call the method based on the query string
		 *
		 */
		public function processApi(){
            //echo "<pre>"; print_r($_REQUEST['rquest']); echo "</pre>";
            $func = strtolower(trim(str_replace("/","",$_REQUEST['rquest'])));
			if((int)method_exists($this,$func) > 0)
				$this->$func();
			else
				$this->response('',404);	// If the method not exist with in this class, response would be "Page not found".
		}
		
		/* 
		 *	Simple login API
		 *  Login must be POST method
		 *  email : <USER EMAIL>
		 *  pwd : <USER PASSWORD>
		 */
		
		private function login(){
			// Cross validation if the request method is POST else it will return "Not Acceptable" status
			/*if($this->get_request_method() != "POST"){
				$this->response('',406);
			}*/
			if (isset($_SERVER['REDIRECT_HTTP_AUTHORIZATION']))
				$basicauth = explode(" ",$_SERVER['REDIRECT_HTTP_AUTHORIZATION']);
			elseif (isset($_SERVER['HTTP_AUTHORIZATION'])) 
				$basicauth = explode(" ",$_SERVER['HTTP_AUTHORIZATION']);
			/*$email = $this->_request['email'];		
			$password = $this->_request['pwd'];*/
			$file = fopen("auth.csv","r");
			$login = false;
			while (($line = fgetcsv($file)) !== FALSE) {
				$auth = base64_encode(implode(":",$line));
				if((string)$basicauth[1] === $auth){
					$login = true;
	                break;
	            }
        	}
        	fclose($file);
        	return $login;
		}
		
		private function users(){	
			// Cross validation if the request method is GET else it will return "Not Acceptable" status
			if($this->get_request_method() != "GET"){
				$this->response('',406);
			}
            if ($sql = $this->db->query("SELECT user_id, firstname, email FROM cscart_users WHERE user_id = 1")) {
				if(mysqli_num_rows($sql) > 0){
					$result = array();
					while($rlt = mysqli_fetch_array($sql,MYSQLI_ASSOC)){
						$result['users'] = $rlt;
					}
					// If success everythig is good send header as "OK" and return list of users in JSON format
					$this->response($this->json($result), 200);
				}
			}
			
			
			$this->response('',204);	// If no records "No Content" status
		}
		
		
		
		
		private function order(){	
			// Cross validation if the request method is GET else it will return "Not Acceptable" status
			if($this->get_request_method() != "POST"){
				$this->response('',406);
			}else{
				$data = json_decode(file_get_contents('php://input'),true);
				
				
				$orderquantity = 0;
				$order_product_data = array();
				$ingredient_data = array();
				foreach($data['products'] as $pkey=>$product){
					
					if ($sql = $this->db->query("SELECT ingredient_id, quantity FROM product_ingredient WHERE product_id = ".$product['product_id'])) {
						if(mysqli_num_rows($sql) > 0){
							$orderquantity += $product['quantity'];
							while($rlt = mysqli_fetch_array($sql,MYSQLI_ASSOC)){
								//echo "<pre>"; print_r($rlt); echo "</pre>";
								//$result['users'] = $rlt;
								
								$order_product_data[$pkey]['product_id'] = $product['product_id'];
								$quantity = ($rlt['quantity']*$product['quantity']);
								if(empty($ingredient_data[$rlt['ingredient_id']])){
									$ingredient_data[$rlt['ingredient_id']] = $quantity;
								}else{
									$ingredient_data[$rlt['ingredient_id']] += $quantity;
								}
							}
							// If success everythig is good send header as "OK" and return list of users in JSON format
							//$this->response($this->json($result), 200);
						}
					}
				}
				$order_products = array();
								
				 if ($ordersql = $this->db->query("INSERT INTO `orders` (`order_id`, `user_id`, `quantity`, `updated_at`) VALUES (NULL, 1, ".$orderquantity.", current_timestamp())")) {
					$order_id = $this->db->insert_id;
					foreach($order_product_data as $okey=>$order_product){
						$order_products[] = '(NULL, '.$order_id.', '.$order_product['product_id'].', current_timestamp())';
					}
					$product_update = $this->db->query("INSERT INTO `order_products` (`id`, `order_id`, `product_id`, `updated_at`) VALUES ".implode(",",$order_products));
					if($product_update){
						foreach($ingredient_data as $ikey=>$idata){
							$this->db->query("UPDATE `ingredient` SET `quantity` = quantity-".$idata." WHERE `ingredient`.`ingredient_id` = ".$ikey);
						}
						$result=array("order_id"=>$order_id);
						$this->response($this->json($result), 200);
					}
					
				} 
			}
			$this->response('',204);	// If no records "No Content" status
		}


		
		
		
		
		
		
		/*
		 *	Encode array into JSON
		*/
		private function json($data){
			if(is_array($data)){
				return json_encode($data);
			}
		}
	}
	
	// Initiiate Library
	
	$api = new API;
	$api->processApi();
?>

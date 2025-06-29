# WordPress Docker Setup with HTTPS

A complete WordPress development environment using Docker with HTTPS support, optimized for Apple Silicon (M1/M2) Macs.

---

## 🚀 Features
- WordPress (latest version)
- MySQL 8.0 database
- Nginx reverse proxy with SSL termination
- HTTPS support with self-signed certificates
- Custom ports to avoid conflicts
- M1/M2 optimized Docker images
- Application Passwords support
- Volume persistence for data

## 📋 Prerequisites
- Docker Desktop for Mac (Apple Silicon support)
- Docker Compose
- OpenSSL (pre-installed on macOS)
- Git

## 🔧 Port Configuration
- **HTTPS:** https://localhost:8443
- **HTTP:** http://localhost:8081 (redirects to HTTPS)
- **MySQL:** localhost:3307

## 🛠️ Quick Start

1. **Clone the Repository**
```bash
git clone <your-repo-url>
cd wordpress-docker-https
```
2. **Generate SSL Certificates**
```bash
chmod +x generate-ssl.sh
./generate-ssl.sh
```
3. **Start the Environment**
```bash
docker-compose up -d
docker-compose ps
```
4. **Access WordPress**
   - Open your browser and go to https://localhost:8443
   - You'll see a security warning (expected for self-signed certificates)
   - Click "Advanced" → "Proceed to localhost (unsafe)"
   - Follow the WordPress installation wizard

5. **WordPress Database Configuration**
   - Database Name: `wordpress`
   - Username: `wordpress`
   - Password: `wordpress_password`
   - Database Host: `db`
   - Table Prefix: `wp_` (default)

## 📁 Project Structure
```
wordpress-docker-https/
├── docker-compose.yml          # Main Docker Compose configuration
├── generate-ssl.sh            # SSL certificate generation script
├── nginx/
│   └── nginx.conf            # Nginx reverse proxy configuration
├── ssl/                      # SSL certificates (auto-generated)
│   ├── localhost.crt
│   └── localhost.key
├── README.md                 # This file
└── .gitignore               # Git ignore file
```

## 🔐 HTTPS Configuration
**Option 1: Accept Self-Signed Certificate (Quick)**
- Proceed through the browser security warning when accessing https://localhost:8443

**Option 2: Trust Certificate System-Wide (Recommended)**
```bash
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ssl/localhost.crt
```
- In Keychain Access:
  - Go to System keychain
  - Find localhost certificate
  - Double-click → Expand Trust
  - Set to Always Trust

**Option 3: Use mkcert for Production-Like Certificates**
```bash
brew install mkcert
mkcert -install
mkcert localhost 127.0.0.1 ::1
mv localhost+2.pem ssl/localhost.crt
mv localhost+2-key.pem ssl/localhost.key
docker-compose restart nginx
```

## 🔧 WordPress Configuration
After installation, add these lines to `wp-config.php` for proper HTTPS handling:
```php
// Force HTTPS detection
if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {
    $_SERVER['HTTPS'] = 'on';
}
// Force SSL for admin
define('FORCE_SSL_ADMIN', true);
// Fix WordPress HTTPS detection
if (isset($_SERVER['HTTP_X_FORWARDED_HOST'])) {
    $_SERVER['HTTP_HOST'] = $_SERVER['HTTP_X_FORWARDED_HOST'];
}
// Set correct site URLs (optional)
define('WP_HOME', 'https://localhost:8443');
define('WP_SITEURL', 'https://localhost:8443');
```

### Editing wp-config.php in Docker
```bash
# Method 1: Edit directly in container
docker exec -it wordpress_app bash
cd /var/www/html
nano wp-config.php

# Method 2: Copy, edit, copy back
docker cp wordpress_app:/var/www/html/wp-config.php ./wp-config.php
# Edit the file locally
docker cp ./wp-config.php wordpress_app:/var/www/html/wp-config.php
```

## 🗄️ Database Management
**Access MySQL Database**
```bash
# From host machine
mysql -h 127.0.0.1 -P 3307 -u wordpress -p
# From within Docker
docker exec -it wordpress_db mysql -u wordpress -p
```
**Database Credentials**
- Host: `localhost:3307` (external) or `db:3306` (internal)
- Database: `wordpress`
- Username: `wordpress`
- Password: `wordpress_password`
- Root Password: `root_password`

## 📊 Docker Management Commands
**Basic Operations**
```bash
docker-compose up -d
docker-compose down
docker-compose restart nginx
docker-compose logs
docker-compose logs wordpress
docker-compose logs nginx
docker-compose logs db
docker-compose ps
```
**Data Management**
```bash
# Backup database
docker exec wordpress_db mysqldump -u wordpress -pwordpress_password wordpress > backup.sql
# Restore database
docker exec -i wordpress_db mysql -u wordpress -pwordpress_password wordpress < backup.sql
# Reset everything (WARNING: Deletes all data)
docker-compose down -v
docker-compose up -d
```

## 🔧 Customization
**Change Ports**
Edit `docker-compose.yml` to modify port mappings:
```yaml
nginx:
  ports:
    - "YOUR_HTTPS_PORT:443"
    - "YOUR_HTTP_PORT:80"
db:
  ports:
    - "YOUR_DB_PORT:3306"
```
**Change Database Credentials**
Update environment variables in `docker-compose.yml`:
```yaml
db:
  environment:
    MYSQL_DATABASE: your_db_name
    MYSQL_USER: your_username
    MYSQL_PASSWORD: your_password
    MYSQL_ROOT_PASSWORD: your_root_password
wordpress:
  environment:
    WORDPRESS_DB_HOST: db:3306
    WORDPRESS_DB_USER: your_username
    WORDPRESS_DB_PASSWORD: your_password
    WORDPRESS_DB_NAME: your_db_name
```
**Nginx Configuration**
Modify `nginx/nginx.conf` for custom Nginx settings like:
- Custom SSL settings
- Additional security headers
- Performance optimizations
- Custom proxy settings

## 🔒 Security Notes
- **Development Only:** This setup uses self-signed certificates and default passwords
- **Change Passwords:** Update all default passwords for any production-like use
- **Firewall:** The services are bound to localhost only
- **Updates:** Regularly update Docker images for security patches

## 📄 License
This project is open source and available under the MIT License.

## 🙏 Acknowledgments
- WordPress team for the excellent CMS
- Docker team for containerization technology
- Nginx team for the robust web server
- MySQL team for the reliable database

---

Happy WordPressing! 🎉

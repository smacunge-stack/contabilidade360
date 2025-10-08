FROM php:8.1-cli

# Instalar dependências
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    zip \
    curl \
    libzip-dev \
    && docker-php-ext-install zip pdo pdo_mysql

# Diretório de trabalho
WORKDIR /var/www

# Copiar projeto Laravel
COPY . .

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

# Instalar dependências Laravel
RUN composer install || true

# Tentar gerar chave (ignorar erro se já existir .env ou APP_KEY)
RUN php artisan key:generate || true

# Expor porta do Laravel
EXPOSE 8000

# Entrar no shell interativo para debugging
CMD ["php", "-S", "0.0.0.0:8000", "-t", "public"]

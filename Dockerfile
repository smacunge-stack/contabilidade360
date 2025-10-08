# Imagem base com PHP e extensões necessárias
FROM php:8.1-cli

# Instalar dependências do sistema
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    zip \
    && docker-php-ext-install zip pdo pdo_mysql

# Definir diretório de trabalho
WORKDIR /var/www

# Copiar os arquivos do projeto
COPY . .

# Instalar o Composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

# Instalar dependências do Laravel
RUN composer install --no-dev

# Gerar chave do app (caso ainda não exista)
RUN php artisan key:generate || true

# Expor a porta do Laravel
EXPOSE 8000

# Rodar o servidor e manter ativo
CMD ["sh", "-c", "php artisan serve --host=0.0.0.0 --port=8000"]
